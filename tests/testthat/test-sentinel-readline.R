test_that("Sentinel: readline input validation prevents integer overflow DoS", {
  mockery::stub(aFIPC::autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  set.seed(42)
  # Data large enough to run without mirt crashing on 2PL
  new_data <- as.data.frame(matrix(sample(0:1, 500 * 5, replace = TRUE), ncol = 5))
  colnames(new_data) <- paste0("Item", 1:5)
  old_data <- as.data.frame(matrix(sample(0:1, 500 * 5, replace = TRUE), ncol = 5))
  colnames(old_data) <- paste0("Item", 1:5)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = paste0("Item", 1:3),
      oldformCommonItemNames = paste0("Item", 1:3),
      confirmCommonItems = NULL,
      itemtype = "2PL",
      tryFitwholeOldItems = FALSE,
      tryFitwholeNewItems = FALSE
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("Sentinel: oldformBILOGprior input validation prevents integer overflow DoS", {
  mockery::stub(aFIPC::autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  set.seed(42)
  new_data <- as.data.frame(matrix(sample(0:1, 1000 * 5, replace = TRUE), ncol = 5))
  colnames(new_data) <- paste0("Item", 1:5)
  old_data <- as.data.frame(matrix(sample(0:1, 1000 * 5, replace = TRUE), ncol = 5))
  colnames(old_data) <- paste0("Item", 1:5)

  # Stub checkCorrect so we bypass the first prompt
  mockery::stub(aFIPC::autoFIPC, "checkCorrect", 1)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = paste0("Item", 1:3),
      oldformCommonItemNames = paste0("Item", 1:3),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      tryFitwholeOldItems = FALSE,
      tryFitwholeNewItems = FALSE
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("Sentinel: newformBILOGprior input validation prevents integer overflow DoS", {
  mockery::stub(aFIPC::autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  set.seed(42)
  new_data <- as.data.frame(matrix(sample(0:1, 1000 * 5, replace = TRUE), ncol = 5))
  colnames(new_data) <- paste0("Item", 1:5)
  old_data <- as.data.frame(matrix(sample(0:1, 1000 * 5, replace = TRUE), ncol = 5))
  colnames(old_data) <- paste0("Item", 1:5)

  # create fake mirt models for testing
  old_model <- suppressWarnings(mirt::mirt(old_data, 1, itemtype = 'Rasch', verbose = FALSE, technical=list(NCYCLES=1)))

  # modify to look like 3PL so autoFIPC tries to do BILOG logic on newform
  old_model@Model$itemtype <- rep("3PL", 5)

  # Stub checkCorrect
  mockery::stub(aFIPC::autoFIPC, "checkCorrect", 1)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_data,
      oldformYData = old_model,
      newformCommonItemNames = paste0("Item", 1:3),
      oldformCommonItemNames = paste0("Item", 1:3),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      tryFitwholeOldItems = FALSE,
      tryFitwholeNewItems = FALSE
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
