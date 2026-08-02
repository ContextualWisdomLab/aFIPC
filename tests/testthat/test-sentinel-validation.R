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

test_that("autoFIPC integer validation works with strictly bounded regex", {
  # Mock readline to return invalid inputs that should fail after 3 attempts
  # override interactive() to TRUE to trigger the readline loop, then mock readline
  with_mockery <- function() {
    mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
    mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('3', '0', '999999999'))
    expect_error(
      aFIPC::autoFIPC(
        newformXData = data.frame(A=1, B=2),
        oldformYData = data.frame(A=1, B=2),
        newformCommonItemNames = c('A', 'B'),
        oldformCommonItemNames = c('A', 'B'),
        confirmCommonItems = NULL
      ),
      "Too many invalid common item confirmation attempts"
    )
  }
  with_mockery()
})

test_that("autoFIPC integer validation accepts valid inputs", {
  # Mock readline to return '1' (valid input)
  with_mockery_valid <- function() {
    mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
    mockery::stub(aFIPC::autoFIPC, 'readline', '1')
    mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) stop('forced failure'))
    mockery::stub(aFIPC::autoFIPC, 'surveyFA', function(...) stop('forced failure'))

    expect_error(
      aFIPC::autoFIPC(
        newformXData = data.frame(A=1, B=2),
        oldformYData = data.frame(A=1, B=2),
        newformCommonItemNames = c('A', 'B'),
        oldformCommonItemNames = c('A', 'B'),
        confirmCommonItems = NULL,
        oldformBILOGprior = NULL,
        newformBILOGprior = NULL
      )
    )
  }
  with_mockery_valid()
})
