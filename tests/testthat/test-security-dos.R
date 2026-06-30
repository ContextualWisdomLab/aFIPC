test_that("autoFIPC common-item confirmation does not recurse in non-interactive mode", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(item1=c(1,0,1)),
      oldformYData = data.frame(item1=c(1,1,0)),
      newformCommonItemNames = c("item1"),
      oldformCommonItemNames = c("item1"),
      itemtype = '3PL'
    ),
    "Common item confirmation requires an interactive session"
  )
})
