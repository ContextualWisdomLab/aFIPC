test_that("ncol() optimization correctly determines number of items from matrix", {
  # We test the newformXData and oldformYData paths explicitly.
  expect_error(
    aFIPC::autoFIPC(
      newformXData = matrix(c(1, 2), nrow = 1, dimnames = list(NULL, c("A", "B"))),
      oldformYData = data.frame(A=2, B=3),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = c("2PL", "2PL", "2PL")
    ),
    "Security Error: itemtype must be length 1 or length 2 \\(number of items\\)."
  )
})
