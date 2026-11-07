library(testthat)

test_that("test surveyFA with dataframe input", {
  raw_df <- data.frame(
    Item1 = c(1, 1, 1, 1),
    Item2 = c(1, 1, 1, 1),
    Item3 = c(0, 0, 0, 0),
    Item4 = c(1, 1, 1, 1),
    Item5 = c(1, 1, 1, 1)
  )

  expect_error(surveyFA(raw_df), "surveyFA needs at least two non-constant response columns.")
})
