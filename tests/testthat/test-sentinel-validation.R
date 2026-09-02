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

test_that("autoFIPC handles large invalid inputs correctly in interactive sessions without crashing", {
  # Using mockery to stub base functions properly in the context of autoFIPC
  mockery::stub(aFIPC::autoFIPC, 'interactive', function() TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("99999999999999999999", "99999999999999999999", "99999999999999999999"))

  # Should stop after 3 attempts due to the new regex validation correctly ignoring large numbers
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
})
