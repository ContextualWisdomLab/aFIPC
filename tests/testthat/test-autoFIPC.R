library(aFIPC)
library(mirt)

test_that("autoFIPC runs with mock data", {
  set.seed(1234)
  # generate mock data
  a <- matrix(c(rlnorm(5, .2, .2), rlnorm(5, .2, .2)), 10, 1)
  d <- matrix(rnorm(10), 10)
  itemtype <- rep('2PL', 10)

  oldform <- simdata(a[1:8, 1, drop=FALSE], d[1:8, 1, drop=FALSE], 500, itemtype[1:8])
  newform <- simdata(a[3:10, 1, drop=FALSE], d[3:10, 1, drop=FALSE], 500, itemtype[3:10])

  colnames(oldform) <- paste0("Item", 1:8)
  colnames(newform) <- paste0("Item", 3:10)

  res <- autoFIPC(
    newformXData = newform,
    oldformYData = oldform,
    newformCommonItemNames = paste0("Item", 3:8),
    oldformCommonItemNames = paste0("Item", 3:8),
    itemtype = "2PL",
    tryEM = TRUE,
    checkIPD = FALSE
  )

  expect_true(is.list(res))
  expect_s4_class(res$oldFormModel, "SingleGroupClass")
  expect_s4_class(res$newFormModel, "SingleGroupClass")
  expect_s4_class(res$LinkedModel, "SingleGroupClass")
})

test_that("autoFIPC runs with IPD check", {
  set.seed(1234)
  # generate mock data
  a <- matrix(c(rlnorm(5, .2, .2), rlnorm(5, .2, .2)), 10, 1)
  d <- matrix(rnorm(10), 10)
  itemtype <- rep('2PL', 10)

  oldform <- simdata(a[1:8, 1, drop=FALSE], d[1:8, 1, drop=FALSE], 500, itemtype[1:8])
  newform <- simdata(a[3:10, 1, drop=FALSE], d[3:10, 1, drop=FALSE], 500, itemtype[3:10])

  colnames(oldform) <- paste0("Item", 1:8)
  colnames(newform) <- paste0("Item", 3:10)

  res <- autoFIPC(
    newformXData = newform,
    oldformYData = oldform,
    newformCommonItemNames = paste0("Item", 3:8),
    oldformCommonItemNames = paste0("Item", 3:8),
    itemtype = "2PL",
    tryEM = TRUE,
    checkIPD = TRUE
  )

  expect_true(is.list(res))
  expect_true(!is.null(res$IPDData))
})
