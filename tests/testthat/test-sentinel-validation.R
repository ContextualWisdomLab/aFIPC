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

test_that("autoFIPC validates invalid readline integer overflow logic safely when passed valid or invalid input", {
  # Mock interactive to true and provide valid answer
  mock_interactive <- function() TRUE
  mockery::stub(aFIPC::autoFIPC, "interactive", mock_interactive)
  mockery::stub(aFIPC::autoFIPC, "readline", mockery::mock("invalid", "invalid", "invalid", cycle=TRUE))

  # Check if syntax runs and raises expected error further down for common item confirmation
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Too many invalid common item confirmation attempts"
  )
})
