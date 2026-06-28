library(aFIPC)
library(mirt)

test_that("autoFIPC handles different item types and freeMEAN=F", {
  set.seed(1234)
  # generate mock data
  a <- matrix(rep(1, 10), 10, 1) # Rasch has a=1
  d <- matrix(rnorm(10), 10)
  itemtype <- rep('dich', 10)

  oldform <- simdata(a[1:8, 1, drop=FALSE], d[1:8, 1, drop=FALSE], 100, itemtype[1:8])
  newform <- simdata(a[3:10, 1, drop=FALSE], d[3:10, 1, drop=FALSE], 100, itemtype[3:10])

  colnames(oldform) <- paste0("Item", 1:8)
  colnames(newform) <- paste0("Item", 3:10)

  res <- autoFIPC(
    newformXData = newform,
    oldformYData = oldform,
    newformCommonItemNames = paste0("Item", 3:8),
    oldformCommonItemNames = paste0("Item", 3:8),
    itemtype = "Rasch",
    tryEM = TRUE,
    checkIPD = FALSE,
    freeMEAN = FALSE
  )

  expect_true(is.list(res))
})

test_that("autoFIPC handles different options", {
  set.seed(1234)
  # generate mock data
  a <- matrix(rep(1, 10), 10, 1)
  d <- matrix(rnorm(10), 10)
  itemtype <- rep('dich', 10)

  oldform <- simdata(a[1:8, 1, drop=FALSE], d[1:8, 1, drop=FALSE], 100, itemtype[1:8])
  newform <- simdata(a[3:10, 1, drop=FALSE], d[3:10, 1, drop=FALSE], 100, itemtype[3:10])

  colnames(oldform) <- paste0("Item", 1:8)
  colnames(newform) <- paste0("Item", 3:10)

  res <- autoFIPC(
    newformXData = newform,
    oldformYData = oldform,
    newformCommonItemNames = paste0("Item", 3:8),
    oldformCommonItemNames = paste0("Item", 3:8),
    itemtype = "Rasch",
    tryEM = FALSE,
    checkIPD = FALSE,
    forceNormalZeroOne = TRUE,
    parameterOverwrite = TRUE
  )

  expect_true(is.list(res))
})

test_that("autoFIPC nominal data", {
  set.seed(1234)
  # generate mock data
  a <- matrix(rep(1, 10), 10, 1)
  d <- matrix(rnorm(10), 10)
  itemtype <- rep('dich', 10)

  oldform <- simdata(a[1:8, 1, drop=FALSE], d[1:8, 1, drop=FALSE], 100, itemtype[1:8])
  newform <- simdata(a[3:10, 1, drop=FALSE], d[3:10, 1, drop=FALSE], 100, itemtype[3:10])

  colnames(oldform) <- paste0("Item", 1:8)
  colnames(newform) <- paste0("Item", 3:10)

  res <- autoFIPC(
    newformXData = newform,
    oldformYData = oldform,
    newformCommonItemNames = paste0("Item", 3:8),
    oldformCommonItemNames = paste0("Item", 3:8),
    itemtype = "Rasch",
    tryEM = FALSE,
    checkIPD = FALSE
  )

  expect_true(is.list(res))
})
