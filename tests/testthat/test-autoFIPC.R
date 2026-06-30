test_that("autoFIPC raises error in non-interactive session for inputs", {
  # interactive() should be FALSE by default in testthat environments
  expect_error(
    aFIPC::autoFIPC(
      newformXData = 1,
      oldformYData = 2,
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Interactive session required for checking correct items"
  )
})
