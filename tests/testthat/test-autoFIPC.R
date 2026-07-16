test_that("autoFIPC raises error in non-interactive session for inputs", {
  # interactive() should be FALSE by default in testthat environments
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Common item confirmation requires an interactive session"
  )
})

test_that("autoFIPC does not implicitly approve supplied common items", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = FALSE
    ),
    "Please write down pairs correctly"
  )
})

test_that("autoFIPC validates input types securely", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = 1,
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Security Error: newformXData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = 123,
      oldformCommonItemNames = c('A')
    ),
    "Security Error: newformCommonItemNames must be a character vector"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = c("3PL", "2PL")
    ),
    "Security Error: itemtype must be length 1 or length 1 \\(number of items\\)."
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = structure(list(), class = "SingleGroupClass"),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE
    ),
    "Security Error: oldformYData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryFitwholeNewItems = "TRUE"
    ),
    "Security Error: tryFitwholeNewItems must be a single non-NA logical value"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryEM = NA
    ),
    "Security Error: tryEM must be a single non-NA logical value"
  )
})

library(mockery)
test_that("interactive inputs are securely validated", {
  mock_readline <- mockery::mock("3", "3", "3", "3", "1", "3", "3", "3", "3", "1", "3", "3", "3", "3", "1")
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline)
  # simulate interactive session
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  # Check validation limits failure when 3 is supplied repeatedly
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("interactive inputs are securely validated for 3PL prior questions", {
  skip_if_not_installed("mirt")

  set.seed(123)
  old_data <- as.data.frame(matrix(sample(0:1, 100, replace=TRUE), ncol=5))
  new_data <- as.data.frame(matrix(sample(0:1, 100, replace=TRUE), ncol=5))
  names(old_data) <- paste0("I", 1:5)
  names(new_data) <- paste0("I", 1:5)

  mock_readline <- mockery::mock("3", "3", "3")
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline)
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = c('I1'),
      oldformCommonItemNames = c('I1'),
      confirmCommonItems = TRUE,
      itemtype = "3PL"
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("interactive inputs are securely validated for 3PL prior questions newform", {
  skip_if_not_installed("mirt")

  set.seed(123)
  old_data <- as.data.frame(matrix(sample(0:1, 100, replace=TRUE), ncol=5))
  new_data <- as.data.frame(matrix(sample(0:1, 100, replace=TRUE), ncol=5))
  names(old_data) <- paste0("I", 1:5)
  names(new_data) <- paste0("I", 1:5)

  # Suppress the mirt 1 cycle warning during the mock model generation
  mock_old_model <- suppressWarnings(mirt::mirt(old_data, 1, itemtype = '3PL', technical = list(NCYCLES = 1), verbose = FALSE))

  mock_readline <- mockery::mock("3", "3", "3")
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline)
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_data,
      oldformYData = mock_old_model,
      newformCommonItemNames = c('I1'),
      oldformCommonItemNames = c('I1'),
      confirmCommonItems = TRUE,
      itemtype = "3PL"
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
