test_that("autoFIPC is exported", {
  expect_true("autoFIPC" %in% getNamespaceExports("aFIPC"))
  expect_true(is.function(aFIPC::autoFIPC))
})

test_that("autoFIPC and aFIPC handle interactive prompts safely", {
  set.seed(123)
  oldData <- matrix(sample(0:1, 100, replace=TRUE), ncol=5)
  colnames(oldData) <- paste0("Item", 1:5)
  newData <- matrix(sample(0:1, 100, replace=TRUE), ncol=5)
  colnames(newData) <- paste0("Item", 4:8)

  # When interactive() is FALSE (default in testthat), it should not hang
  expect_error(
    aFIPC::aFIPC(oldformYData = oldData, newformXData = newData, itemtype = "3PL", oldformBILOGprior = NULL, newformBILOGprior = NULL)
  )

  expect_error(
    aFIPC::autoFIPC(oldformYData = oldData, newformXData = newData, newformCommonItemNames = c("Item4", "Item5"), oldformCommonItemNames = c("Item4", "Item5"), itemtype = "3PL", oldformBILOGprior = NULL, newformBILOGprior = NULL)
  )
})
