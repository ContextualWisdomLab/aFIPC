library(aFIPC)
test_that("get_confirmation handles correct inputs", {
  # Test "1"
  expect_equal(
    get_confirmation("msg", .readline = function(...) "1", .interactive = function() TRUE),
    1L
  )

  # Test "2"
  expect_equal(
    get_confirmation("msg", .readline = function(...) "2", .interactive = function() TRUE),
    2L
  )
})

test_that("get_confirmation fails on non-interactive", {
  expect_error(
    get_confirmation("msg", .interactive = function() FALSE),
    "Interactive session required for prompt"
  )
})

test_that("get_confirmation fails on invalid inputs after 3 attempts", {
  invalid_count <- 0
  mock_readline <- function(...) {
    invalid_count <<- invalid_count + 1
    return("invalid")
  }

  expect_error(
    get_confirmation("msg", .readline = mock_readline, .interactive = function() TRUE),
    "Too many invalid attempts"
  )
  expect_equal(invalid_count, 3)
})

test_that("get_confirmation succeeds after 1 or 2 invalid attempts", {
  invalid_count <- 0
  mock_readline <- function(...) {
    invalid_count <<- invalid_count + 1
    if (invalid_count < 3) return("invalid")
    return("1")
  }

  expect_equal(
    get_confirmation("msg", .readline = mock_readline, .interactive = function() TRUE),
    1L
  )
  expect_equal(invalid_count, 3)
})
