library(testthat)
library(mirt)
library(mockery)

test_that("autoFIPC validates input correctly", {
  expect_error(autoFIPC(matrix(1), matrix(1), c("i1", "i2"), c("i1")), "Common Items are not equal")
  expect_error(autoFIPC(matrix(1), matrix(1), c(), c()), "Please provide common item names")

  expect_error(autoFIPC(matrix(1), matrix(1), c("i1"), c("i1"), confirmCommonItems = NULL),
               "Common item confirmation requires an interactive session")

  expect_error(autoFIPC(matrix(1), matrix(1), c("i1"), c("i1"), confirmCommonItems = FALSE), "Please write down pairs correctly")
})

test_that("autoFIPC execution with cache logic", {
  set.seed(123)

  N <- 500
  theta <- rnorm(N)
  a <- matrix(rep(1, 5), ncol=1)
  d <- matrix(c(1, 0.5, 0, -0.5, -1), ncol=1)

  old_data <- simdata(a, d, N, itemtype="2PL")
  new_data <- simdata(a, d, N, itemtype="2PL")

  colnames(old_data) <- c("i1", "i2", "i3", "i4", "i5")
  colnames(new_data) <- c("i1", "i6", "i7", "i8", "i9")

  res <- autoFIPC(new_data, old_data, c("i1"), c("i1"), itemtype = "2PL", confirmCommonItems = TRUE,
               checkIPD = FALSE, tryFitwholeNewItems=FALSE, tryFitwholeOldItems=FALSE)

  expect_true(is.list(res))
  expect_true(!is.null(res$oldFormModel))
  expect_true(!is.null(res$newFormModel))
  expect_true(!is.null(res$LinkedModel))
})
