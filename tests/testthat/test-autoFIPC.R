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

test_that("autoFIPC handles interactive input securely (DoS fix)", {
  # We test the checkCorrect logic using mocking to bypass interactive() stops
  # and supply a valid/invalid choice to our newly patched validation logic.

  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  # Invalid inputs will loop 3 times and fail securely.
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("invalid", "123456789012345", "yes"))
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Too many invalid common item confirmation attempts"
  )

  # Valid input
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("1", cycle = TRUE))
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    # It passes the first check and stops at model fitting or next steps
    "Security Error: Initial estimation of oldFormModel completely failed"
  )
})

test_that("autoFIPC handles oldformBILOGprior interactive input securely", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  # Stub oldFormModel estimation to avoid estimation errors earlier in the function
  dummy_model <- new("SingleGroupClass")
  dummy_model@OptimInfo <- list(secondordertest = TRUE)
  dummy_model@ParObjects$pars <- list()
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', dummy_model)

  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("invalid", "invalid", "invalid", cycle = TRUE))
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      itemtype = '3PL'
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("autoFIPC handles newformBILOGprior interactive input securely", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  dummy_model <- new("SingleGroupClass")
  dummy_model@OptimInfo <- list(secondordertest = TRUE)
  dummy_model@ParObjects$pars <- list()
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', dummy_model)

  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("invalid", "invalid", "invalid", cycle = TRUE))
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      oldformBILOGprior = TRUE,
      itemtype = '3PL'
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})

test_that("autoFIPC handles interactive newformBILOGprior acceptance", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  dummy_model <- new("SingleGroupClass")
  dummy_model@OptimInfo <- list(secondordertest = TRUE)
  dummy_model@ParObjects$pars <- list()
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', dummy_model)

  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("1", cycle = TRUE))
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      oldformBILOGprior = TRUE,
      itemtype = '3PL'
    ),
    "subscript out of bounds"
  )
})
