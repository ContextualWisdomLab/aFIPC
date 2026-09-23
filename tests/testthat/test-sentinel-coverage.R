test_that("sentinel exact match validation handles values correctly", {
  expect_equal("1" %in% c("1", "2"), TRUE)
  expect_equal("2" %in% c("1", "2"), TRUE)
  expect_equal("3" %in% c("1", "2"), FALSE)
  expect_equal("a" %in% c("1", "2"), FALSE)
})
