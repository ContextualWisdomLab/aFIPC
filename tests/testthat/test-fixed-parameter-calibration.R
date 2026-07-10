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
  old_data[1, ] <- 0
  old_data[2, ] <- 1
  new_data[1, ] <- 0
  new_data[2, ] <- 1
  old_data[3, old_common_items[1]] <- NA
  new_data[3, new_common_items[1]] <- NA

  old_model <- mirt::mirt(
    old_data,
    1,
    itemtype = "2PL",
    method = "EM",
    SE = TRUE,
    verbose = FALSE,
    technical = list(NCYCLES = 500)
  )
  new_model <- mirt::mirt(
    new_data,
    1,
    itemtype = "2PL",
    method = "EM",
    SE = TRUE,
    verbose = FALSE,
    technical = list(NCYCLES = 500)
  )

  old_vcov <- as.matrix(old_model@vcov)
  new_vcov <- as.matrix(new_model@vcov)
  expect_gt(nrow(old_vcov), 0)
  expect_gt(nrow(new_vcov), 0)
  expect_true(all(is.finite(diag(old_vcov))))
  expect_true(all(is.finite(diag(new_vcov))))
  expect_true(isTRUE(old_model@OptimInfo$secondordertest))
  expect_true(isTRUE(new_model@OptimInfo$secondordertest))

  linked <- aFIPC::autoFIPC(
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

  linked_vcov <- as.matrix(linked$LinkedModel@vcov)
  expect_gt(nrow(linked_vcov), 0)
  expect_true(all(is.finite(diag(linked_vcov))))
  expect_true(isTRUE(linked$LinkedModel@OptimInfo$secondordertest))

  old_values <- mirt::mod2values(old_model)
  linked_values <- mirt::mod2values(linked$LinkedModel)
  linked_structural <- linked_values[
    linked_values$item %in% new_item_names[5:6] &
      linked_values$name %in% c("g", "u"),
    "est"
  ]
  expect_false(any(linked_structural))

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

  # Kim (2006) invariant, second half: parameters of the NON-common new-form
  # items must stay free (estimated) so they move onto the fixed base scale,
  # rather than being frozen along with the anchors.
  new_unique_items <- setdiff(new_item_names, new_common_items)
  free_new <- linked_values[
    linked_values$item %in% new_unique_items & linked_values$name %in% c("a1", "d"),
    "est"
  ]
  expect_true(all(free_new))

  old_estimates <- old_values[
    old_values$item %in% old_common_items & old_values$name %in% c("a1", "d"),
    "value"
  ]
  true_parameters <- c(rbind(old_a[1:4, 1], old_d[1:4]))
  expect_lt(mean(abs(old_estimates - true_parameters)), 0.35)
})
