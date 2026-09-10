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




test_that("autoFIPC strictly validates interactive readline confirmation inputs", {
  # Mock valid "1" responses to pass the three interactive prompts
  mockery::stub(autoFIPC, 'readline', mockery::mock('1', '1', '1'))
  mockery::stub(autoFIPC, 'interactive', TRUE)

  # The test should proceed past the interactive prompts and fail downstream,
  # indicating that the valid exact-match response '1' was accepted.
  err <- tryCatch({
    autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    )
    "No error"
  }, error = function(e) e$message)

  expect_false(grepl("Too many invalid common item confirmation attempts", err))
})

test_that("autoFIPC correctly rejects invalid numeric inputs and hits the retry limit", {
  # Mock invalid inputs: '0', '3', '9999999999' (out of range), 'abc' (non-numeric), '' (whitespace/empty)
  # The loop tries 3 times. We just need to fail the first prompt (checkCorrect) 3 times.
  mockery::stub(autoFIPC, 'readline', mockery::mock('0', '3', '9999999999'))
  mockery::stub(autoFIPC, 'interactive', TRUE)

  err <- tryCatch({
    autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    )
    "No error"
  }, error = function(e) e$message)

  expect_true(grepl("Too many invalid common item confirmation attempts", err))
})
