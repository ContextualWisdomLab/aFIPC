test_that("autoFIPC handles non-interactive sessions securely to prevent DoS (checkCorrect)", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = matrix(0, nrow=10, ncol=10),
      oldformYData = matrix(0, nrow=10, ncol=10),
      newformCommonItemNames = c("Item1"),
      oldformCommonItemNames = c("Item1")
    ),
    "Common item confirmation requires an interactive session"
  )
})
