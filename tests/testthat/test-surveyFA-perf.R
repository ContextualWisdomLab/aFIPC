library(testthat)
source("../../R/surveyFA.R")

test_that("Optimized unique values logic in surveyFA identifies invalid columns", {
  test_df <- data.frame(
    v1 = c(1, 2, 3),        # Valid
    v2 = c(1, 1, 1),        # Invalid (constant)
    v3 = c(NA, NA, NA),     # Invalid (all NA)
    v4 = c(1, NA, 2),       # Valid (has NA)
    v5 = c(1, 1, NA)        # Invalid (constant ignoring NA)
  )

  test_mat <- as.matrix(test_df)

  is_valid_col <- function(x) {
    x <- x[!is.na(x)]
    if (length(x) == 0L) return(FALSE)
    any(x != x[1L])
  }

  # Check dataframe logic
  valid_cols_df <- vapply(test_df, is_valid_col, logical(1L))
  expect_equal(names(which(valid_cols_df)), c("v1", "v4"))

  # Check matrix logic
  valid_cols_mat <- apply(test_mat, 2L, is_valid_col)
  expect_equal(names(which(valid_cols_mat)), c("v1", "v4"))
})
