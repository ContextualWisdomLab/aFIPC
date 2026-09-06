test_that("autoFIPC validates boolean flags for newformBILOGprior, oldformBILOGprior, and confirmCommonItems", {
  # newformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      newformBILOGprior = "TRUE"
    ),
    "Security Error: newformBILOGprior must be a single non-NA logical value or NULL"
  )

  # oldformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      oldformBILOGprior = c(TRUE, FALSE)
    ),
    "Security Error: oldformBILOGprior must be a single non-NA logical value or NULL"
  )

  # confirmCommonItems
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NA
    ),
    "Security Error: confirmCommonItems must be a single non-NA logical value or NULL"
  )
})

test_that("autoFIPC strict readline validation bounds integer overflow inputs", {
  # Avoid real execution overhead: use a dummy S4 object to represent models
  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mod@OptimInfo$secondordertest <- TRUE

  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  # Mock 'surveyFA' to throw an error so we short-circuit the execution immediately after checking our logic
  mockery::stub(aFIPC::autoFIPC, 'surveyFA', function(...) stop('forced failure'))

  # Mock 'mirt::mirt' to always return our dummy model to bypass actual fitting
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) mod)

  # Provide valid dataframes to pass initial checks
  new_df <- data.frame(A=c(1,0,1))
  old_df <- data.frame(A=c(1,1,0))

  # Test checkCorrect (confirmCommonItems = NULL)

  # Should reject invalid inputs and fail after 3 attempts
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('0', '3', ' 1', 'a', '9999999999'))
  expect_error(
    aFIPC::autoFIPC(newformXData = new_df, oldformYData = old_df, newformCommonItemNames = 'A', oldformCommonItemNames = 'A', confirmCommonItems = NULL),
    "Too many invalid common item confirmation attempts"
  )

  # Accepts exactly '1' or '2'
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('0', '2'))
  expect_error(
    aFIPC::autoFIPC(newformXData = new_df, oldformYData = old_df, newformCommonItemNames = 'A', oldformCommonItemNames = 'A', confirmCommonItems = NULL),
    "Please write down pairs correctly"
  )
})

test_that("autoFIPC strict readline validation bounds integer overflow inputs for BILOG priors", {
  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mod@OptimInfo$secondordertest <- TRUE

  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'surveyFA', function(...) stop('forced failure'))
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) mod)

  new_df <- data.frame(A=c(1,0,1))
  old_df <- data.frame(A=c(1,1,0))

  # Should reject invalid inputs and fail after 3 attempts
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('1', '0', '3', ' 1', 'a', '9999999999'))
  expect_error(
    aFIPC::autoFIPC(newformXData = new_df, oldformYData = old_df, newformCommonItemNames = 'A', oldformCommonItemNames = 'A', confirmCommonItems = NULL, itemtype = '3PL', oldformBILOGprior = NULL),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("autoFIPC strict readline validation bounds integer overflow inputs for newform BILOG priors", {
  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mod@OptimInfo$secondordertest <- TRUE

  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'surveyFA', function(...) stop('forced failure'))
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) mod)

  new_df <- data.frame(A=c(1,0,1))
  old_df <- data.frame(A=c(1,1,0))

  # Should reject invalid inputs and fail after 3 attempts
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('1', '0', '3', ' 1', 'a', '9999999999'))
  expect_error(
    aFIPC::autoFIPC(newformXData = new_df, oldformYData = old_df, newformCommonItemNames = 'A', oldformCommonItemNames = 'A', confirmCommonItems = NULL, itemtype = '3PL', newformBILOGprior = NULL, oldformBILOGprior = TRUE),
    "Too many invalid newform BILOG prior attempts"
  )
})
