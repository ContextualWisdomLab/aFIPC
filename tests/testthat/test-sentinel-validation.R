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

test_that("interactive prompt readline validates inputs strictly", {
  # Mock interactive to return TRUE and mock readline input
  # We test that an invalid input (e.g. '3' or '9999999999') will cause the retry loop to fail

  mock_interactive <- mockery::mock(TRUE, cycle=TRUE)
  mock_readline_fail <- mockery::mock("3", "999", "a", cycle=TRUE)

  mockery::stub(aFIPC::autoFIPC, "interactive", mock_interactive)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_fail)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=c(1,0,1)),
      oldformYData = data.frame(A=c(1,1,0)),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("interactive prompt readline validates inputs strictly for BILOG priors", {

  mock_interactive <- mockery::mock(TRUE, cycle=TRUE)
  mock_readline_fail <- mockery::mock("3", "999", "a", cycle=TRUE)

  mockery::stub(aFIPC::autoFIPC, "interactive", mock_interactive)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_fail)

  # For oldformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=c(1,0,1)),
      oldformYData = data.frame(A=c(1,1,0)),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      itemtype = '3PL'
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("interactive prompt readline validates inputs strictly for newform BILOG priors", {

  mock_interactive <- mockery::mock(TRUE, cycle=TRUE)
  mock_readline_fail <- mockery::mock("3", "999", "a", cycle=TRUE)

  mockery::stub(aFIPC::autoFIPC, "interactive", mock_interactive)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_fail)

  # To reach newformBILOGprior we need oldformBILOGprior to pass, so we pass it explicitly
  # We also need enough data to not fail the mirt 3PL estimation
  set.seed(123)
  N <- 100
  new_data <- data.frame(
    A = rbinom(N, 1, 0.5),
    B = rbinom(N, 1, 0.5),
    C = rbinom(N, 1, 0.5),
    D = rbinom(N, 1, 0.5),
    E = rbinom(N, 1, 0.5)
  )
  old_data <- data.frame(
    A = rbinom(N, 1, 0.5),
    B = rbinom(N, 1, 0.5),
    C = rbinom(N, 1, 0.5),
    D = rbinom(N, 1, 0.5),
    F = rbinom(N, 1, 0.5)
  )
  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = c('A', 'B', 'C', 'D'),
      oldformCommonItemNames = c('A', 'B', 'C', 'D'),
      confirmCommonItems = TRUE,
      itemtype = '3PL',
      oldformBILOGprior = FALSE
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})

test_that("integer overflow via interactive readline coercion is prevented", {

  mock_interactive <- mockery::mock(TRUE, cycle=TRUE)
  # This uses a value that would cause integer overflow if not strictly matched
  mock_readline_overflow <- mockery::mock("99999999999999999999", cycle=TRUE)

  mockery::stub(aFIPC::autoFIPC, "interactive", mock_interactive)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_overflow)

  # It should fail validation with "Too many invalid common item confirmation attempts"
  # instead of crashing with coercion/type errors
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=c(1,0,1)),
      oldformYData = data.frame(A=c(1,1,0)),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Too many invalid common item confirmation attempts"
  )
})
