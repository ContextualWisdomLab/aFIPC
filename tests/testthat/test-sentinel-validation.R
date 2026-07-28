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

test_that("autoFIPC integer validation bounds work for interactive prompts", {
  library(mockery)

  # Mock interactive() to return TRUE so we enter the readline loop
  mock_interactive <- mock(TRUE, cycle = TRUE)
  stub(aFIPC::autoFIPC, 'interactive', mock_interactive)

  # Stub checkCorrect readline with '3' which is invalid, it should fail
  mock_readline <- mock("3", "3", "3", cycle = TRUE)
  stub(aFIPC::autoFIPC, 'readline', mock_readline)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=c(1,0,1)),
      oldformYData = data.frame(A=c(0,1,0)),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NULL # explicit NULL ensures we hit checkCorrect prompt
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("autoFIPC integer validation bounds work for oldform and newform BILOG prior prompts", {
  library(mockery)

  mock_interactive <- mock(TRUE, cycle = TRUE)
  stub(aFIPC::autoFIPC, 'interactive', mock_interactive)

  mock_readline <- mock("3", "3", "3", cycle = TRUE)
  stub(aFIPC::autoFIPC, 'readline', mock_readline)

  # Need at least 4 items for mirt to fit the model initially without crashing before hitting newform prompt
  df <- data.frame(A=c(1,0,1,0,1), B=c(0,1,0,1,0), C=c(1,1,0,0,1), D=c(0,0,1,1,0), E=c(1,0,1,0,1))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = df,
      oldformYData = df,
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      itemtype = '3PL',
      oldformBILOGprior = NULL,
      newformBILOGprior = TRUE,
      checkIPD = FALSE
    ),
    "Too many invalid oldform BILOG prior attempts"
  )

  # Stub oldform model directly so it bypasses fitting and goes to newform BILOG prompt
  mock_oldformModel <- mirt::mirt(df, 1, itemtype='2PL', verbose=FALSE)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = df,
      oldformYData = mock_oldformModel,
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      itemtype = '3PL',
      oldformBILOGprior = TRUE,
      newformBILOGprior = NULL,
      checkIPD = FALSE
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
