test_that("autoFIPC MAP pre-calculation optimization works without interactive prompts", {
  skip_if_not_installed("mirt")
  library(mirt)

  # create simple dataset
  set.seed(123)
  dat_old <- expand.table(LSAT7)
  dat_new <- expand.table(LSAT7)

  # modify a little to distinguish
  dat_new[1:50, 1] <- sample(0:1, 50, replace = TRUE)

  model_old <- mirt(dat_old, 1, itemtype = 'Rasch', SE = FALSE)
  model_new <- mirt(dat_new, 1, itemtype = 'Rasch', SE = FALSE)

  c_items <- colnames(dat_old)[1:2]

  # run function - should NOT hang on interactive prompts and should finish
  result <- aFIPC::autoFIPC(
    newformXData = model_new,
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
  )

  expect_true(is.list(result))
  expect_true(inherits(result$LinkedModel, "SingleGroupClass"))
})
