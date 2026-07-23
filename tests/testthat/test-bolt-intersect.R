test_that("intersect column name extraction works properly in autoFIPC", {
  skip_if_not_installed("mirt")
  set.seed(42)

  a <- matrix(c(1, 1.2, 0.8, 1.5, 0.9, 1.1, 1.0, 1.3), ncol=1)
  d <- matrix(c(1, -1, 0, 0.5, -0.5, 0, 0.2, -0.2), ncol=1)
  oldformYData <- mirt::simdata(a, d, 250, itemtype = '2PL')
  colnames(oldformYData) <- paste0("Item", 1:8)

  a2 <- matrix(c(1, 1.2, 0.8, 1.0, 1.3), ncol=1)
  d2 <- matrix(c(1, -1, 0, 0.2, -0.2), ncol=1)
  newformXData <- mirt::simdata(a2, d2, 250, itemtype = '2PL')
  colnames(newformXData) <- c("Item1", "Item2", "Item3", "NewItem1", "NewItem2")

  result <- aFIPC::autoFIPC(
    newformXData = newformXData,
    oldformYData = oldformYData,
    newformCommonItemNames = c('Item1', 'Item2', 'Item3'),
    oldformCommonItemNames = c('Item1', 'Item2', 'Item3'),
    confirmCommonItems = FALSE, # This skips interactive confirmation
    tryEM = TRUE,
    freeMEAN = FALSE,
    forceNormalZeroOne = FALSE,
    tryFitwholeOldItems = FALSE,
    tryFitwholeNewItems = FALSE
  )

  expect_true(!is.null(result$LinkedModel))
  expect_true(methods::is(result$LinkedModel, "SingleGroupClass"))
})
