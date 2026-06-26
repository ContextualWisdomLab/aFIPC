test_that("autoFIPC passes securely without interactive prompt", {
  library(mirt)

  a <- matrix(c(1,1,2,2,3,3), ncol=2)
  b <- matrix(c(1,1,2,2,3,3), ncol=2)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = a,
      oldformYData = b,
      newformCommonItemNames = c("Item1"),
      oldformCommonItemNames = c("Item1")
    ),
    "Interactive prompt is not available"
  )
})
