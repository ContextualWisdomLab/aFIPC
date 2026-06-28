library(aFIPC)
library(mirt)

test_that("autoFIPC handles ideal data or second order test failure", {
  set.seed(1234)
  # generate mock data
  a <- matrix(rep(1, 10), 10, 1)
  d <- matrix(rep(0, 10), 10)
  itemtype <- rep('ideal', 10)

  oldform <- simdata(a[1:8, 1, drop=FALSE], d[1:8, 1, drop=FALSE], 10, itemtype[1:8])
  newform <- simdata(a[3:10, 1, drop=FALSE], d[3:10, 1, drop=FALSE], 10, itemtype[3:10])

  colnames(oldform) <- paste0("Item", 1:8)
  colnames(newform) <- paste0("Item", 3:10)

  res <- autoFIPC(
    newformXData = newform,
    oldformYData = oldform,
    newformCommonItemNames = paste0("Item", 3:8),
    oldformCommonItemNames = paste0("Item", 3:8),
    itemtype = "ideal",
    tryFitwholeOldItems = FALSE,
    tryFitwholeNewItems = FALSE,
    tryEM = TRUE,
    checkIPD = FALSE
  )

  expect_true(is.list(res))
})
