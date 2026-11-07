library(testthat)

test_that("test surveyFA with matrix input", {
  raw_mat <- matrix(
    c(
      1, 1, 1, 1, 1,
      1, 1, 1, 1, 1,
      1, 1, 1, 1, 1,
      1, 1, 1, 1, 1
    ),
    nrow = 4, byrow = TRUE,
    dimnames = list(NULL, paste0("Item", 1:5))
  )

  expect_error(surveyFA(raw_mat), "surveyFA needs at least two non-constant response columns.")
})
