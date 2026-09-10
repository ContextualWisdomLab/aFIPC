test_that("Sentinel: oldformBILOGprior interactive prompt validation prevents integer overflow DoS", {
  mockery::stub(aFIPC::autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  set.seed(42)
  new_data <- as.data.frame(matrix(sample(0:1, 1000 * 5, replace = TRUE), ncol = 5))
  colnames(new_data) <- c("Item1", "Item2", "Item3", "Item4", "Item5")
  old_data <- as.data.frame(matrix(sample(0:1, 1000 * 5, replace = TRUE), ncol = 5))
  colnames(old_data) <- c("Item1", "Item2", "Item3", "Item4", "Item5")

  old_model <- mirt::mirt(old_data, 1, itemtype = '3PL', verbose = FALSE, technical=list(NCYCLES=10))
  new_model <- mirt::mirt(new_data, 1, itemtype = '3PL', verbose = FALSE, technical=list(NCYCLES=10))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = c('Item1', 'Item2'),
      oldformCommonItemNames = c('Item1', 'Item2'),
      confirmCommonItems = TRUE,
      itemtype = "3PL"
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("Sentinel: newformBILOGprior interactive prompt validation prevents integer overflow DoS", {
  # Stub so checkoldformBILOGprior returns 1 to bypass the first check
  mockery::stub(aFIPC::autoFIPC, "checkoldformBILOGprior", 1)
  mockery::stub(aFIPC::autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  set.seed(42)
  new_data <- as.data.frame(matrix(sample(0:1, 1000 * 5, replace = TRUE), ncol = 5))
  colnames(new_data) <- c("Item1", "Item2", "Item3", "Item4", "Item5")
  old_data <- as.data.frame(matrix(sample(0:1, 1000 * 5, replace = TRUE), ncol = 5))
  colnames(old_data) <- c("Item1", "Item2", "Item3", "Item4", "Item5")

  old_model <- mirt::mirt(old_data, 1, itemtype = '3PL', verbose = FALSE, technical=list(NCYCLES=10))
  new_model <- mirt::mirt(new_data, 1, itemtype = '3PL', verbose = FALSE, technical=list(NCYCLES=10))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = c('Item1', 'Item2'),
      oldformCommonItemNames = c('Item1', 'Item2'),
      confirmCommonItems = TRUE,
      itemtype = "3PL"
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
