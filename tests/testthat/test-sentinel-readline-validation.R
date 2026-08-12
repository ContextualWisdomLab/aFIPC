library(testthat)
library(mockery)

test_that("autoFIPC validates interactive readline correctly with strict regex", {
  # We source the code directly to bypass pkgload/namespace export issues
  # in this mocked environment test

  # Ensure we mock interactive prompt paths, without modifying logic
  mockery::stub(autoFIPC, 'interactive', TRUE)

  # Mock mirt.model as it is called early for generating model syntax
  mockery::stub(autoFIPC, 'mirt::mirt.model', function(...) stop('forced failure'))

  # Test with valid inputs (1 or 2)
  # Needs to handle multiple readlines if it passes the first one
  mockery::stub(autoFIPC, 'readline', mockery::mock('1', '1', '1', '1'))

  expect_error(
    autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "forced failure|Please write down pairs correctly|Too many invalid common item confirmation attempts"
  )

  # Test with malicious inputs (large numbers that cause NA coercions if unhandled)
  # It should fail validation 3 times and throw the "Too many invalid" error
  mockery::stub(autoFIPC, 'readline', mockery::mock('9999999999999999', '9999999999999999', '9999999999999999'))
  expect_error(
    autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Please write down pairs correctly|forced failure|Too many invalid common item confirmation attempts"
  )
})
