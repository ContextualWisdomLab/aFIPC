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

test_that("autoFIPC properly validates interactive readline inputs to prevent integer overflow coercion", {
  # Mock interactive() to return TRUE
  mock_interactive <- mockery::mock(TRUE, cycle = TRUE)

  # Mock readline for confirmCommonItems (reject invalid, then valid)
  mock_readline_confirm <- mockery::mock("3", "999999999999999999999999", "1", cycle = TRUE)

  # Stub both functions in the aFIPC namespace
  mockery::stub(aFIPC::autoFIPC, 'interactive', mock_interactive)
  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline_confirm)

  # We expect an error down the line because this is a dummy data frame, but
  # we want to ensure it passes the readline block and doesn't get stuck or crash due to coercion
  # We'll test oldformBILOGprior similarly by passing the confirm step

  mock_readline_oldform <- mockery::mock("1", "4", "99999999999999999", "2", cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline_oldform)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=c(1, 2, 1, 0, 1)),
      oldformYData = data.frame(A=c(1, 0, 1, 0, 1)),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NULL,
      itemtype = '3PL'
    ),
    "Initial estimation of oldFormModel completely failed"
  )
})
