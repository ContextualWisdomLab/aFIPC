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


test_that("getInteractiveConfirmation correctly validates valid inputs", {
  mockery::stub(getInteractiveConfirmation, 'readline', mockery::mock('1', '2'))
  mockery::stub(getInteractiveConfirmation, 'interactive', TRUE)

  expect_equal(getInteractiveConfirmation("prompt", "error"), 1L)
  expect_equal(getInteractiveConfirmation("prompt", "error"), 2L)
})

test_that("getInteractiveConfirmation correctly rejects invalid numeric inputs and hits the retry limit", {
  mockery::stub(getInteractiveConfirmation, 'readline', mockery::mock('0', '3', '9999999999'))
  mockery::stub(getInteractiveConfirmation, 'interactive', TRUE)

  expect_error(getInteractiveConfirmation("prompt", "error"), "error")
})
