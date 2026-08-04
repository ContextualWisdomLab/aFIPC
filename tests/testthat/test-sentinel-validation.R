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

test_that("autoFIPC handles extremely large inputs for readline safely via mockery", {
  # Mock the readline function to simulate an attacker trying to crash the program
  # with a huge number string that exceeds the max integer limit
  mock_readline <- mockery::mock(
    "99999999999999999999999999", # Attempt 1: Too large
    "invalid",                   # Attempt 2: Letters
    "1",                         # Attempt 3: Valid input
    cycle = TRUE
  )
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline)

  # Set up data structure that won't fail mirt validation, but will trigger readline

  if (requireNamespace("mirt", quietly = TRUE)) {
    data(LSAT7, package = "mirt")

    # use multiple items for mirt models so there are enough degrees of freedom
    mod1 <- mirt::mirt(LSAT7, 1, verbose = FALSE, SE = FALSE)
    mod2 <- mirt::mirt(LSAT7, 1, verbose = FALSE, SE = FALSE)

    # To bypass errors that occur during fscores mapping of multiple items vs single common item
    # we just need to test that it reaches beyond the readline block safely.
    # If the readline validation fails, we get a crash or integer overflow NA.
    # We wrap in try to safely catch mirt errors downstream, knowing our regex block completed.

    capture.output({
      try({
        out <- aFIPC::autoFIPC(
          newformXData = mod2,
          oldformYData = mod1,
          newformCommonItemNames = c('Item.1'),
          oldformCommonItemNames = c('Item.1'),
          confirmCommonItems = NULL
        )
      }, silent = TRUE)
    })

    # 3 attempts should have been made successfully matching our mockery mock
    expect_equal(length(mockery::mock_calls(mock_readline)), 3)
  }
})
