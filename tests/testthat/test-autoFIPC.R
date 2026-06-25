test_that("autoFIPC handles non-interactive mode safely", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A = 1),
      oldformYData = data.frame(B = 1),
      newformCommonItemNames = "A",
      oldformCommonItemNames = "B"
    ),
    "object 'oldFormModel' not found|The following items have only one response category and cannot be estimated"
  )
})
