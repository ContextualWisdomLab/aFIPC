test_that("autoFIPC handles non-interactive readline properly without unbounded recursion", {
  expect_error(
    aFIPC::autoFIPC(
      oldformYData = matrix(c(1,0,1,0), nrow=2),
      newformXData = matrix(c(1,0,1,0), nrow=2),
      newformCommonItemNames = "Item1",
      oldformCommonItemNames = "Item2"
    ),
    "Too many invalid input attempts"
  )
})
