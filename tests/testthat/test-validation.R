library(testthat)

test_that("Input validation logic matches expected patterns", {
  expect_false(grepl("^[12]$", "invalid"))
  expect_false(grepl("^[12]$", "3"))
  expect_false(grepl("^[12]$", "10"))
  expect_false(grepl("^[12]$", "20"))
  expect_true(grepl("^[12]$", "1"))
  expect_true(grepl("^[12]$", "2"))
})
