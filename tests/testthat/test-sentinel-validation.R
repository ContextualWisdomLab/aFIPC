test_that("autoFIPC validates boolean flags for newformBILOGprior, oldformBILOGprior, and confirmCommonItems", {
  # newformBILOGprior
  expect_error(
    autoFIPC(
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
    autoFIPC(
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
    autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NA
    ),
    "Security Error: confirmCommonItems must be a single non-NA logical value or NULL"
  )
})

test_that("large numbers do not cause NA coercion errors in autoFIPC readline prompt", {

  # Give a huge number that passes ^[0-9]+$ but fails as.integer()
  # Then give a valid '2' to continue if it rejects the first one
  m <- mockery::mock("999999999999999999999999999999", "2", "2", "2")
  mockery::stub(autoFIPC, 'readline', m)
  mockery::stub(autoFIPC, 'interactive', TRUE)

  # Check that it rejects the large number correctly by prompting again (which gives 2) and thus stopping
  expect_error({
      autoFIPC(
        newformXData = data.frame(A=c(1,0,1,0), B=c(1,1,0,0)),
        oldformYData = data.frame(A=c(1,0,1,0), B=c(1,1,0,0)),
        newformCommonItemNames = c('A'),
        oldformCommonItemNames = c('A'),
        confirmCommonItems = NULL
      )
  }, "Please write down pairs correctly")
})
