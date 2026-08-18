library(testthat)

test_that("autoFIPC handles invalid readline inputs securely", {
  # We test the actual aFIPC::autoFIPC function using mockery to stub readline
  # We use mockery::stub on the internal functions that call readline

  # Dummy input data
  new_model <- data.frame(matrix(rnorm(20), nrow=10))
  old_model <- data.frame(matrix(rnorm(20), nrow=10))

  # Stub interactive to return TRUE so we enter the readline branch
  mockery::stub(autoFIPC, 'interactive', TRUE)

  # Mock readline to return a large number that caused the NA DoS previously
  # We use forced failure to simulate the 3 failed attempts
  mock_readline <- mockery::mock("1000000000000", "1000000000000", "1000000000000")
  mockery::stub(autoFIPC, 'readline', mock_readline)

  # When confirmCommonItems is NULL, it prompts. If it fails 3 times, it stops.
  expect_error(
    autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = "X1",
      oldformCommonItemNames = "X1",
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})
