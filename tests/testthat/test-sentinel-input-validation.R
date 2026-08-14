binary_prompt_data <- function(row_count = 40L) {
  set.seed(20260813)
  data.frame(
    item_1 = stats::rbinom(row_count, 1L, 0.45),
    item_2 = stats::rbinom(row_count, 1L, 0.55),
    item_3 = stats::rbinom(row_count, 1L, 0.50),
    item_4 = stats::rbinom(row_count, 1L, 0.60)
  )
}

test_that("common-item confirmation rejects oversized integer input after three attempts", {
  testthat::local_mocked_bindings(
    interactive = function() TRUE,
    readline = testthat::mock_output_sequence(
      "999999999999999999999",
      "999999999999999999999",
      "999999999999999999999"
    ),
    .package = "aFIPC"
  )

  response_data <- binary_prompt_data()
  expect_error(
    suppressMessages(aFIPC::autoFIPC(
      newformXData = response_data,
      oldformYData = response_data,
      newformCommonItemNames = c("item_1", "item_2"),
      oldformCommonItemNames = c("item_1", "item_2"),
      itemtype = "2PL"
    )),
    "Too many invalid common item confirmation attempts",
    fixed = TRUE
  )
})

test_that("old-form BILOG prompt rejects values outside the documented binary choices", {
  testthat::local_mocked_bindings(
    interactive = function() TRUE,
    readline = testthat::mock_output_sequence(
      "1",
      "0",
      "3",
      "999999999999999999999"
    ),
    .package = "aFIPC"
  )

  response_data <- binary_prompt_data()
  expect_error(
    suppressMessages(aFIPC::autoFIPC(
      newformXData = response_data,
      oldformYData = response_data,
      newformCommonItemNames = c("item_1", "item_2"),
      oldformCommonItemNames = c("item_1", "item_2"),
      itemtype = "3PL"
    )),
    "Too many invalid oldform BILOG prior attempts",
    fixed = TRUE
  )
})

test_that("new-form BILOG prompt applies the same bounded validation contract", {
  skip_if_not_installed("mirt")

  set.seed(20260814)
  item_names <- paste0("item_", 1:4)
  old_data <- as.data.frame(mirt::simdata(
    a = matrix(c(0.9, 1.1, 0.8, 1.2), ncol = 1L),
    d = c(-0.5, 0.0, 0.5, 0.8),
    itemtype = rep("2PL", 4L),
    N = 250L
  ))
  names(old_data) <- item_names
  old_model <- mirt::mirt(
    old_data,
    1L,
    itemtype = "2PL",
    SE = FALSE,
    verbose = FALSE,
    technical = list(NCYCLES = 300L)
  )

  testthat::local_mocked_bindings(
    interactive = function() TRUE,
    readline = testthat::mock_output_sequence(
      "1",
      "0",
      "3",
      "999999999999999999999"
    ),
    .package = "aFIPC"
  )

  new_data <- binary_prompt_data(row_count = 250L)
  expect_error(
    suppressMessages(aFIPC::autoFIPC(
      newformXData = new_data,
      oldformYData = old_model,
      newformCommonItemNames = c("item_1", "item_2"),
      oldformCommonItemNames = c("item_1", "item_2"),
      itemtype = "3PL"
    )),
    "Too many invalid newform BILOG prior attempts",
    fixed = TRUE
  )
})
