
test_that("aFIPC::autoFIPC validates boolean flags for newformBILOGprior, oldformBILOGprior, and confirmCommonItems", {
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


test_that("aFIPC::autoFIPC handles DoS via oversized integer in readline using regex validation", {
  # Mock interactive to return TRUE so we reach readline
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  # Provide inputs that will trigger the first readline for confirmCommonItems
  # when confirmCommonItems = NULL (the default)
  newformXData <- data.frame(item1 = c(0,1), item2 = c(1,0))
  oldformYData <- data.frame(item1 = c(1,0), item2 = c(0,1))

  # Stub readline to return '999999999999999999999' which fails the ^[12]$ strict regex
  # It will loop 3 times and fail with "Too many invalid common item confirmation attempts"
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('999999999999999999999', '999999999999999999999', '999999999999999999999'))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = newformXData,
      oldformYData = oldformYData,
      newformCommonItemNames = c('item1'),
      oldformCommonItemNames = c('item1'),
      confirmCommonItems = NULL,
      itemtype = 'Rasch'
    ),
    "Too many invalid common item confirmation attempts"
  )
})
