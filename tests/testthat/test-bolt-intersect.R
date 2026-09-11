test_that("model metadata preserves linked-form column order", {
  skip_if_not_installed("mirt")
  set.seed(42)

  old_discrimination <- matrix(
    c(1, 1.2, 0.8, 1.5, 0.9, 1.1, 1.0, 1.3),
    ncol = 1
  )
  old_intercept <- matrix(
    c(1, -1, 0, 0.5, -0.5, 0, 0.2, -0.2),
    ncol = 1
  )
  oldform_data <- mirt::simdata(
    old_discrimination,
    old_intercept,
    250,
    itemtype = "2PL"
  )
  colnames(oldform_data) <- paste0("Item", 1:8)

  new_discrimination <- matrix(c(1, 1.2, 0.8, 1.0, 1.3), ncol = 1)
  new_intercept <- matrix(c(1, -1, 0, 0.2, -0.2), ncol = 1)
  newform_data <- mirt::simdata(
    new_discrimination,
    new_intercept,
    250,
    itemtype = "2PL"
  )
  colnames(newform_data) <- c(
    "Item1",
    "Item2",
    "Item3",
    "NewItem1",
    "NewItem2"
  )

  result <- aFIPC::autoFIPC(
    newformXData = newform_data,
    oldformYData = oldform_data,
    newformCommonItemNames = c("Item1", "Item2", "Item3"),
    oldformCommonItemNames = c("Item1", "Item2", "Item3"),
    itemtype = "2PL",
    confirmCommonItems = TRUE,
    tryEM = TRUE,
    checkIPD = FALSE,
    freeMEAN = FALSE,
    forceNormalZeroOne = FALSE,
    tryFitwholeOldItems = FALSE,
    tryFitwholeNewItems = FALSE
  )

  expect_s4_class(result$LinkedModel, "SingleGroupClass")
  expect_identical(
    colnames(result$newFormModel@Data$data),
    colnames(newform_data)
  )
  expect_identical(
    colnames(result$LinkedModel@Data$data),
    colnames(newform_data)
  )
})
