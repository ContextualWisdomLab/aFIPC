source(testthat::test_path("fixtures", "fipc-regression-fixtures.R"), local = TRUE)

extract_group_parameter <- function(model, parameter_name_pattern) {
  values <- mirt::mod2values(model)
  values[
    values$item == "GROUP" & grepl(parameter_name_pattern, values$name),
    ,
    drop = FALSE
  ]
}

extract_data_frame_row_values <- function(data, row) {
  vapply(
    data[row, , drop = FALSE],
    function(column) as.character(column[[1]]),
    character(1)
  )
}

test_that("prior-update fixture distinguishes free-mean and fixed-normal linking", {
  skip_if_not_installed("mirt")

  fx <- regression_fixture_prior_update
  set.seed(fx$seed)

  old_common_items <- paste0("old_common_", seq_len(fx$common_count))
  new_common_items <- paste0("new_common_", seq_len(fx$common_count))
  old_unique_items <- paste0("old_unique_", seq_len(fx$unique_count))
  new_unique_items <- paste0("new_unique_", seq_len(fx$unique_count))

  old_item_names <- c(old_common_items, old_unique_items)
  new_item_names <- c(new_common_items, new_unique_items)

  old_a <- matrix(
    c(0.88, 1.05, 1.19, 0.93, 1.12, 0.99, 1.28, 0.76),
    ncol = 1
  )
  old_d <- c(-1.20, -0.65, -0.20, 0.10, 0.55, 0.95, -0.35, 0.60)
  new_a <- matrix(
    c(0.88, 1.05, 1.19, 0.93, 1.12, 0.99, 1.38, 0.70),
    ncol = 1
  )
  new_d <- c(-1.20, -0.65, -0.20, 0.10, 0.55, 0.95, 0.25, 1.10)

  theta_old <- matrix(
    rnorm(fx$n_old, mean = fx$old_theta_mean, sd = fx$old_theta_sd),
    ncol = 1
  )
  theta_new <- matrix(
    rnorm(fx$n_new, mean = fx$new_theta_mean, sd = fx$new_theta_sd),
    ncol = 1
  )

  old_data <- as.data.frame(mirt::simdata(
    a = old_a,
    d = old_d,
    itemtype = rep(fx$itemtype, length(old_item_names)),
    Theta = theta_old
  ))
  new_data <- as.data.frame(mirt::simdata(
    a = new_a,
    d = new_d,
    itemtype = rep(fx$itemtype, length(new_item_names)),
    Theta = theta_new
  ))
  names(old_data) <- old_item_names
  names(new_data) <- new_item_names

  old_model <- mirt::mirt(
    old_data,
    1,
    itemtype = fx$itemtype,
    method = "EM",
    SE = FALSE,
    verbose = FALSE,
    technical = list(NCYCLES = 600)
  )
  new_model <- mirt::mirt(
    new_data,
    1,
    itemtype = fx$itemtype,
    method = "EM",
    SE = FALSE,
    verbose = FALSE,
    technical = list(NCYCLES = 600)
  )

  linked_free <- suppressWarnings(aFIPC::autoFIPC(
    newformXData = new_model,
    oldformYData = old_model,
    newformCommonItemNames = new_common_items,
    oldformCommonItemNames = old_common_items,
    itemtype = fx$itemtype,
    checkIPD = FALSE,
    tryEM = TRUE,
    freeMEAN = TRUE,
    forceNormalZeroOne = FALSE,
    confirmCommonItems = TRUE
  ))

  linked_fixed <- suppressWarnings(aFIPC::autoFIPC(
    newformXData = new_model,
    oldformYData = old_model,
    newformCommonItemNames = new_common_items,
    oldformCommonItemNames = old_common_items,
    itemtype = fx$itemtype,
    checkIPD = FALSE,
    tryEM = TRUE,
    freeMEAN = FALSE,
    forceNormalZeroOne = TRUE,
    confirmCommonItems = TRUE
  ))

  free_mean <- extract_group_parameter(linked_free$LinkedModel, "MEAN")
  fixed_mean <- extract_group_parameter(linked_fixed$LinkedModel, "MEAN")
  fixed_cov <- extract_group_parameter(linked_fixed$LinkedModel, "COV")

  expect_true(any(free_mean$est))
  expect_gt(abs(free_mean$value[1]), fx$expect_shifted_mean_abs_gt)
  expect_false(any(fixed_mean$est))
  expect_equal(fixed_mean$value[1], 0, tolerance = 1e-8)
  expect_false(any(fixed_cov$est))
  expect_equal(fixed_cov$value[1], 1, tolerance = 1e-8)
})

test_that("IPD fixture filters anchors before fixed-parameter linking", {
  skip_if_not_installed("mirt")

  fx <- regression_fixture_ipd_anchor
  set.seed(fx$seed)

  old_common_items <- paste0("old_anchor_", seq_len(fx$common_count))
  new_common_items <- paste0("new_anchor_", seq_len(fx$common_count))
  old_unique_items <- paste0("old_unique_", seq_len(fx$unique_count))
  new_unique_items <- paste0("new_unique_", seq_len(fx$unique_count))

  old_item_names <- c(old_common_items, old_unique_items)
  new_item_names <- c(new_common_items, new_unique_items)

  old_a <- matrix(
    c(0.90, 1.07, 1.18, 0.96, 1.10, 0.87, 1.33, 0.78),
    ncol = 1
  )
  old_d <- c(-1.10, -0.55, -0.15, 0.20, 0.70, 1.05, -0.40, 0.50)
  new_a <- old_a
  new_d <- old_d

  drift_index <- fx$drift_common_index
  new_a[drift_index, 1] <- 1.85
  new_d[drift_index] <- 2.20

  old_data <- as.data.frame(mirt::simdata(
    a = old_a,
    d = old_d,
    itemtype = rep(fx$itemtype, length(old_item_names)),
    N = fx$n_old
  ))
  new_data <- as.data.frame(mirt::simdata(
    a = new_a,
    d = new_d,
    itemtype = rep(fx$itemtype, length(new_item_names)),
    N = fx$n_new
  ))
  names(old_data) <- old_item_names
  names(new_data) <- new_item_names

  old_model <- mirt::mirt(
    old_data,
    1,
    itemtype = fx$itemtype,
    method = "EM",
    SE = FALSE,
    verbose = FALSE,
    technical = list(NCYCLES = 600)
  )
  new_model <- mirt::mirt(
    new_data,
    1,
    itemtype = fx$itemtype,
    method = "EM",
    SE = FALSE,
    verbose = FALSE,
    technical = list(NCYCLES = 600)
  )

  linked <- suppressMessages(suppressWarnings(
    aFIPC::autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = new_common_items,
      oldformCommonItemNames = old_common_items,
      itemtype = fx$itemtype,
      checkIPD = TRUE,
      tryEM = TRUE,
      confirmCommonItems = TRUE
    )
  ))

  expect_true("IPDData" %in% names(linked))
  expect_true("IPDCommonItemList" %in% names(linked))
  expect_equal(nrow(linked$IPDCommonItemList), 2)
  expect_equal(nrow(linked$IPDData), fx$n_old + fx$n_new)
  expect_true("IPDgroup" %in% names(linked$IPDData))

  retained_old <- extract_data_frame_row_values(linked$IPDCommonItemList, 1)
  retained_new <- extract_data_frame_row_values(linked$IPDCommonItemList, 2)

  expect_lt(length(retained_old), length(old_common_items))
  expect_equal(length(retained_old), length(retained_new))
  expect_true(all(retained_old %in% old_common_items))
  expect_true(all(retained_new %in% new_common_items))

  old_values <- mirt::mod2values(old_model)
  linked_values <- mirt::mod2values(linked$LinkedModel)
  mean_abs_distance <- numeric(length(retained_old))

  for (i in seq_along(retained_old)) {
    old_item <- retained_old[i]
    new_item <- retained_new[i]
    old_fixed <- old_values[
      old_values$item == old_item & old_values$name %in% c("a1", "d"),
      c("name", "value")
    ]
    linked_fixed <- linked_values[
      linked_values$item == new_item & linked_values$name %in% c("a1", "d"),
      c("name", "value", "est")
    ]
    aligned <- merge(old_fixed, linked_fixed, by = "name", sort = FALSE)
    mean_abs_distance[i] <- mean(abs(aligned$value.x - aligned$value.y))
    expect_false(any(linked_fixed$est))
  }

  expect_lt(mean(mean_abs_distance), 1e-6)
})
