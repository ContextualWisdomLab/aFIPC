test_that("ncol() optimization correctly determines number of items from matrix", {
  # Test the newformXData path explicitly.
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

  # Test the oldformYData path explicitly.
  # We construct an S4 SingleGroupClass from mirt using mock data but provide sufficient
  # parameters to prevent mirt from crashing during internal check inside `aFIPC`.

  dummy_data <- matrix(sample(c(0, 1), 100, replace=TRUE), 20, 5)
  colnames(dummy_data) <- paste0("Item", 1:5)

  suppressMessages(suppressWarnings({
    real_mirt_model <- mirt::mirt(dummy_data, 1, itemtype = "2PL", TOL = 0.5, verbose=FALSE)
  }))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = real_mirt_model,
      oldformYData = matrix(c(1, 2, 3), nrow = 1, dimnames = list(NULL, c("A", "B", "C"))),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = c("2PL", "2PL")
    ),
    "Security Error: itemtype must be length 1 or length 3 \\(number of items\\)."
  )
})
