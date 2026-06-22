test_that("autoFIPC input functions do not infinite loop in non-interactive mode", {
  # We test the internal functions behavior if possible, or verify error is thrown

  # checkCorrect is internal to autoFIPC, so we mock interactive() if needed,
  # but in testthat, interactive() is already FALSE.
  # Calling autoFIPC with missing or invalid args that trigger the prompts
  # should now fail with "Non-interactive session or too many invalid attempts"
  # instead of infinite recursion.

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(item1=c(1,0,1)),
      oldformYData = data.frame(item1=c(1,1,0)),
      newformCommonItemNames = c("item1"),
      oldformCommonItemNames = c("item1"),
      itemtype = '3PL'
    ),
    "Non-interactive session or too many invalid attempts"
  )
})
