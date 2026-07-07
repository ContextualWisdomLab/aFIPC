test_that("autoFIPC covers different execution paths", {
  skip_if_not_installed("mirt")
  library(mirt)

  # create simple dataset
  set.seed(123)
  dat_old <- expand.table(LSAT7)
  dat_new <- expand.table(LSAT7)

  # modify a little to distinguish
  dat_new[1:50, 1] <- sample(0:1, 50, replace = TRUE)

  # Data frame path instead of model path
  c_items <- colnames(dat_old)[1:2]

  # Run function with data frames
  result_df <- aFIPC::autoFIPC(
    newformXData = dat_new,
    oldformYData = dat_old,
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = 'Rasch',
    tryFitwholeNewItems = FALSE,
    tryFitwholeOldItems = FALSE,
    checkIPD = TRUE,
    tryEM = TRUE,
    freeMEAN = TRUE,
    forceNormalZeroOne = FALSE,
    parameterOverwrite = FALSE,
    empiricalhist = FALSE
  )

  expect_true(is.list(result_df))
  expect_true(inherits(result_df$LinkedModel, "SingleGroupClass"))

  # Run with IPD and other configurations
  result_ipd <- aFIPC::autoFIPC(
    newformXData = mirt(dat_new, 1, itemtype = 'Rasch', SE = FALSE),
    oldformYData = mirt(dat_old, 1, itemtype = 'Rasch', SE = FALSE),
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = 'Rasch',
    tryFitwholeNewItems = FALSE,
    tryFitwholeOldItems = FALSE,
    checkIPD = TRUE,
    tryEM = TRUE,
    freeMEAN = FALSE,
    forceNormalZeroOne = TRUE,
    parameterOverwrite = TRUE,
    empiricalhist = FALSE
  )

  expect_true(is.list(result_ipd))
})

test_that("autoFIPC handles missing items or mismatched lengths", {
  # Error path for mismatched length
  expect_error(aFIPC::autoFIPC(
    newformXData = matrix(), oldformYData = matrix(),
    newformCommonItemNames = c("Item 1"), oldformCommonItemNames = c("Item 1", "Item 2")
  ), "Common Items are not equal")

  # Error path for empty items
  expect_error(aFIPC::autoFIPC(
    newformXData = matrix(), oldformYData = matrix(),
    newformCommonItemNames = character(0), oldformCommonItemNames = character(0)
  ), "Please provide common item names")
})


test_that("autoFIPC handles combinations part 6", {
  skip_if_not_installed("mirt")
  library(mirt)

  set.seed(123)
  dat_old <- expand.table(LSAT7)
  dat_new <- expand.table(LSAT7)
  dat_new[1:50, 1] <- sample(0:1, 50, replace = TRUE)

  c_items <- colnames(dat_old)[1:2]

  expect_error(aFIPC::autoFIPC(
    newformXData = dat_new,
    oldformYData = dat_old,
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = 'Rasch',
    tryFitwholeNewItems = FALSE,
    tryFitwholeOldItems = FALSE,
    checkIPD = FALSE,
    tryEM = FALSE,
    freeMEAN = FALSE,
    forceNormalZeroOne = TRUE,
    parameterOverwrite = TRUE,
    empiricalhist = FALSE,
    oldformBILOGprior = TRUE,
    newformBILOGprior = TRUE
  ), NA)

  # Check with oldformYData as model instead of dataframe
  model_old <- mirt(dat_old, 1, itemtype = 'Rasch', SE = FALSE)
  model_new <- mirt(dat_new, 1, itemtype = 'Rasch', SE = FALSE)

  expect_error(aFIPC::autoFIPC(
    newformXData = model_new,
    oldformYData = model_old,
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = 'nominal',
    tryFitwholeNewItems = FALSE,
    tryFitwholeOldItems = FALSE,
    checkIPD = FALSE,
    tryEM = TRUE,
    freeMEAN = FALSE,
    forceNormalZeroOne = FALSE,
    parameterOverwrite = TRUE,
    empiricalhist = FALSE
  ), NA)

  aFIPC::autoFIPC(
    newformXData = dat_new,
    oldformYData = dat_old,
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = '3PL',
    tryFitwholeNewItems = TRUE,
    tryFitwholeOldItems = TRUE,
    checkIPD = FALSE,
    tryEM = TRUE,
    freeMEAN = TRUE,
    forceNormalZeroOne = FALSE,
    parameterOverwrite = FALSE,
    empiricalhist = FALSE,
    oldformBILOGprior = FALSE,
    newformBILOGprior = FALSE
  )
  expect_true(TRUE)
})

test_that("autoFIPC covers QMCEM estimation failure mode", {
  skip_if_not_installed("mirt")
  library(mirt)

  set.seed(123)
  dat_old <- matrix(sample(c(0, 1), 100, replace = TRUE), ncol = 5)
  dat_new <- matrix(sample(c(0, 1), 100, replace = TRUE), ncol = 5)

  c_items <- colnames(dat_old)[1:2]

  expect_error(aFIPC::autoFIPC(
    newformXData = dat_new,
    oldformYData = dat_old,
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = 'Rasch',
    tryFitwholeNewItems = TRUE,
    tryFitwholeOldItems = TRUE,
    checkIPD = FALSE,
    tryEM = FALSE,
    freeMEAN = FALSE,
    forceNormalZeroOne = FALSE,
    parameterOverwrite = TRUE,
    empiricalhist = FALSE
  ))
})


test_that("autoFIPC covers errors", {
  skip_if_not_installed("mirt")
  library(mirt)

  set.seed(123)
  dat_old <- expand.table(LSAT7)
  dat_new <- expand.table(LSAT7)

  # make dat_old terrible so that it fails to estimate
  dat_old[] <- 0

  c_items <- colnames(dat_old)[1:2]

  expect_error(aFIPC::autoFIPC(
    newformXData = dat_new,
    oldformYData = dat_old,
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = 'Rasch',
    tryFitwholeNewItems = TRUE,
    tryFitwholeOldItems = TRUE,
    checkIPD = FALSE,
    tryEM = TRUE,
    freeMEAN = TRUE,
    forceNormalZeroOne = FALSE,
    parameterOverwrite = FALSE,
    empiricalhist = FALSE
  ))
})

test_that("autoFIPC handles different itemtype and tryEM settings", {
  skip_if_not_installed("mirt")
  library(mirt)

  set.seed(123)
  dat_old <- expand.table(LSAT7)
  dat_new <- expand.table(LSAT7)
  dat_new[1:50, 1] <- sample(0:1, 50, replace = TRUE)

  c_items <- colnames(dat_old)[1:2]

  # For itemtype = '3PL', checkoldformBILOGprior triggers if oldformBILOGprior is NULL
  expect_error(aFIPC::autoFIPC(
    newformXData = dat_new,
    oldformYData = dat_old,
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = '3PL',
    tryFitwholeNewItems = FALSE,
    tryFitwholeOldItems = FALSE,
    checkIPD = FALSE,
    tryEM = TRUE,
    freeMEAN = TRUE,
    forceNormalZeroOne = FALSE,
    parameterOverwrite = FALSE,
    empiricalhist = FALSE,
    oldformBILOGprior = NULL,
    newformBILOGprior = NULL
  ), NA)

  # Check with oldformYData as model instead of dataframe
  model_old <- mirt(dat_old, 1, itemtype = 'Rasch', SE = FALSE)
  expect_error(aFIPC::autoFIPC(
    newformXData = dat_new,
    oldformYData = model_old,
    newformCommonItemNames = c_items,
    oldformCommonItemNames = c_items,
    itemtype = 'Rasch',
    tryFitwholeNewItems = FALSE,
    tryFitwholeOldItems = FALSE,
    checkIPD = FALSE,
    tryEM = TRUE,
    freeMEAN = TRUE,
    forceNormalZeroOne = FALSE,
    parameterOverwrite = FALSE,
    empiricalhist = FALSE
  ), NA)
})
