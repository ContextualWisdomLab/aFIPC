library(testthat)

test_that("binary prompt parser accepts only the declared choices", {
  parse_choice <- getFromNamespace(".parse_binary_choice", "aFIPC")

  expect_identical(parse_choice("1"), 1L)
  expect_identical(parse_choice("2"), 2L)
  expect_true(is.na(parse_choice("3")))
  expect_true(is.na(parse_choice("10")))
  expect_true(is.na(parse_choice("2147483648")))
  expect_true(is.na(parse_choice("invalid")))
  expect_true(is.na(parse_choice("")))
})
