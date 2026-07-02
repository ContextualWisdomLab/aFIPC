test_that("autoFIPC fixes common-item parameters on the old-form scale", {
  skip_if_not_installed("mirt")

  set.seed(20260629)
  old_item_names <- paste0("old_item_", 1:6)
  new_item_names <- paste0("new_item_", 1:6)
  old_common_items <- old_item_names[1:4]
  new_common_items <- new_item_names[1:4]
  old_a <- matrix(c(0.82, 1.05, 1.28, 0.96, 1.15, 0.74), ncol = 1)
  old_d <- c(-1.05, -0.35, 0.15, 0.85, -0.65, 0.45)
  new_a <- matrix(c(0.82, 1.05, 1.28, 0.96, 0.88, 1.36), ncol = 1)
  new_d <- c(-1.05, -0.35, 0.15, 0.85, -0.05, 0.95)

  old_data <- as.data.frame(mirt::simdata(
    a = old_a,
    d = old_d,
    itemtype = rep("2PL", length(old_item_names)),
    N = 1600
  ))
  new_data <- as.data.frame(mirt::simdata(
    a = new_a,
    d = new_d,
    itemtype = rep("2PL", length(new_item_names)),
    N = 1600
  ))
  names(old_data) <- old_item_names
  names(new_data) <- new_item_names

  old_model <- mirt::mirt(
    old_data,
    1,
    itemtype = "2PL",
    method = "EM",
    SE = FALSE,
    verbose = FALSE,
    technical = list(NCYCLES = 500)
  )
  new_model <- mirt::mirt(
    new_data,
    1,
    itemtype = "2PL",
    method = "EM",
    SE = FALSE,
    verbose = FALSE,
    technical = list(NCYCLES = 500)
  )

  linked <- suppressWarnings(
    aFIPC::autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = new_common_items,
      oldformCommonItemNames = old_common_items,
      itemtype = "2PL",
      checkIPD = FALSE,
      tryEM = TRUE,
      freeMEAN = FALSE,
      forceNormalZeroOne = TRUE,
      confirmCommonItems = TRUE
    )
  )

  old_values <- mirt::mod2values(old_model)
  linked_values <- mirt::mod2values(linked$LinkedModel)

  for (i in seq_along(old_common_items)) {
    old_item <- old_common_items[i]
    new_item <- new_common_items[i]
    old_fixed <- old_values[
      old_values$item == old_item & old_values$name %in% c("a1", "d"),
      c("name", "value")
    ]
    linked_fixed <- linked_values[
      linked_values$item == new_item & linked_values$name %in% c("a1", "d"),
      c("name", "value", "est")
    ]

    expect_equal(linked_fixed$name, old_fixed$name)
    expect_equal(linked_fixed$value, old_fixed$value, tolerance = 1e-6)
    expect_false(any(linked_fixed$est))
  }

  old_estimates <- old_values[
    old_values$item %in% old_common_items & old_values$name %in% c("a1", "d"),
    "value"
  ]
  true_parameters <- c(rbind(old_a[1:4, 1], old_d[1:4]))
  expect_lt(mean(abs(old_estimates - true_parameters)), 0.35)
})
