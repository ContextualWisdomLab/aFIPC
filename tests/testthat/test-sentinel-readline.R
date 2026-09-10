test_that("Sentinel: oldformBILOGprior interactive prompt validation prevents integer overflow DoS", {
  mockery::stub(aFIPC::autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  # Provide models directly to bypass the slow estimation step
  set.seed(42)
  new_data <- as.data.frame(matrix(sample(0:1, 100 * 20, replace = TRUE), ncol = 20))
  colnames(new_data) <- paste0("Item", 1:20)
  old_data <- as.data.frame(matrix(sample(0:1, 100 * 20, replace = TRUE), ncol = 20))
  colnames(old_data) <- paste0("Item", 1:20)

  # create fake mirt models for testing
  old_model <- mirt::mirt(old_data, 1, itemtype = 'Rasch', verbose = FALSE, TOL = 1000)
  new_model <- mirt::mirt(new_data, 1, itemtype = 'Rasch', verbose = FALSE, TOL = 1000)

  # modify them to look like 3PL so autoFIPC tries to do BILOG logic
  old_model@Model$itemtype <- rep("3PL", 20)
  new_model@Model$itemtype <- rep("3PL", 20)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = paste0("Item", 1:20),
      oldformCommonItemNames = paste0("Item", 1:20),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      # Prevent autoFIPC from trying to fit 3PL which fails with small data
      tryFitwholeOldItems = FALSE,
      tryFitwholeNewItems = FALSE
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("Sentinel: newformBILOGprior interactive prompt validation prevents integer overflow DoS", {
  mockery::stub(aFIPC::autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  set.seed(42)
  new_data <- as.data.frame(matrix(sample(0:1, 100 * 20, replace = TRUE), ncol = 20))
  colnames(new_data) <- paste0("Item", 1:20)
  old_data <- as.data.frame(matrix(sample(0:1, 100 * 20, replace = TRUE), ncol = 20))
  colnames(old_data) <- paste0("Item", 1:20)

  # create fake mirt models for testing
  old_model <- mirt::mirt(old_data, 1, itemtype = 'Rasch', verbose = FALSE, TOL = 1000)
  new_model <- mirt::mirt(new_data, 1, itemtype = 'Rasch', verbose = FALSE, TOL = 1000)

  # modify them to look like 3PL so autoFIPC tries to do BILOG logic
  old_model@Model$itemtype <- rep("3PL", 20)
  new_model@Model$itemtype <- rep("3PL", 20)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = paste0("Item", 1:20),
      oldformCommonItemNames = paste0("Item", 1:20),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      oldformBILOGprior = TRUE,
      tryFitwholeOldItems = FALSE,
      tryFitwholeNewItems = FALSE
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
