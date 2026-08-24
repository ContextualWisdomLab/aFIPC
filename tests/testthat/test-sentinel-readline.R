test_that("autoFIPC strictly validates readline inputs against DoS", {
  testthat::skip_if_not_installed("aFIPC")

  # Stub out the interactive() call
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  # Stub out readline() to return an excessively long invalid integer string
  mockery::stub(aFIPC::autoFIPC, "readline", "99999999999999999999")

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
