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

test_that("autoFIPC input validation for readline protects against coercion DoS", {
  # Mock interactive to TRUE to enter readline paths
  mock_interactive <- mockery::mock(TRUE, TRUE, TRUE)
  mockery::stub(aFIPC::autoFIPC, 'interactive', mock_interactive)

  # 1. confirmCommonItems
  mock_readline_confirm <- mockery::mock("99999999999999999999", "3", "invalid")
  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline_confirm)

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

  # 2. oldformBILOGprior
  mockery::stub(aFIPC::autoFIPC, 'interactive', mockery::mock(TRUE, TRUE, TRUE))
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("1")) # Pass confirmCommonItems

  # Stub nested function call to simulate readline failures specifically for oldformBILOGprior
  mock_readline_oldform <- mockery::mock("99999999999999999999", "3", "invalid")
  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline_oldform, depth = 2) # checkoldformBILOGprior

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1, B=2),
      oldformYData = data.frame(A=1, B=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      itemtype = "3PL"
    ),
    "Too many invalid oldform BILOG prior attempts"
  )

  # 3. newformBILOGprior
  mock_readline_newform <- mockery::mock("99999999999999999999", "3", "invalid")
  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline_newform, depth = 2)

  # Need an oldFormModel so it reaches newform estimation
  mock_old_model <- mirt::mirt(data.frame(A=c(1,0,1,0,1,0,1,0,1,0,1,0), B=c(0,1,0,1,0,1,0,1,0,1,0,1), C=c(1,1,0,0,1,1,0,0,1,1,0,0), D=c(0,0,1,1,0,0,1,1,0,0,1,1)), 1, itemtype="2PL", TOL=0.1, SE=FALSE, GenRandomPars=TRUE)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=c(1,0,1,0,1,0,1,0,1,0,1,0), B=c(0,1,0,1,0,1,0,1,0,1,0,1), C=c(1,1,0,0,1,1,0,0,1,1,0,0), D=c(0,0,1,1,0,0,1,1,0,0,1,1)),
      oldformYData = mock_old_model,
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      oldformBILOGprior = TRUE
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
