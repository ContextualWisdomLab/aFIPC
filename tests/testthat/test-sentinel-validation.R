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

test_that("autoFIPC integer overflow in interactive prompt validation", {
  # Mock interactive environment and multiple invalid readline inputs
  mock_interactive <- mockery::mock(TRUE, cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, "interactive", mock_interactive)

  # Check validation for checkCorrect() common items prompt
  mock_readline_common <- mockery::mock("999999999999999999", "abc", "0", cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_common)

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

  # Validate interactive readline validation accepts 1
  mock_readline_success <- mockery::mock("1", "1", "1", cycle = TRUE)

  mockery::stub(aFIPC::autoFIPC, "interactive", mock_interactive)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_success)

  # For oldformBILOGprior interactive prompt
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=c(1,0,1,0)),
      oldformYData = data.frame(A=c(1,1,0,0)),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NULL,
      itemtype = '3PL',
      oldformBILOGprior = NULL
    ),
    "Security Error: oldformYData must be a data.frame, matrix, or a valid fitted mirt model|Security Error: Initial estimation of oldFormModel completely failed|Common Items are not equal|Security Error: itemtype must be length|The following items have only one response category|Too few degrees of freedom"
  )
})
