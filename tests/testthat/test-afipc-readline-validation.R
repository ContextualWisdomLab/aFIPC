test_that("binary choice admission retries invalid text before accepting 1 or 2", {
  inputs <- c("3", "9999999999999999999", "1")
  calls <- 0L
  reader <- function(prompt) {
    calls <<- calls + 1L
    inputs[[calls]]
  }

  expect_warning(
    choice <- aFIPC:::.read_binary_choice(
      prompt = "confirm",
      failure_message = "too many invalid attempts",
      read_input = reader
    ),
    NA
  )
  expect_identical(choice, 1L)
  expect_identical(calls, 3L)
})

test_that("binary choice admission preserves exact-string semantics", {
  for (invalid in c("3", " 1", "+1", "01", "9999999999999999999")) {
    inputs <- c(invalid, "2")
    calls <- 0L
    reader <- function(prompt) {
      calls <<- calls + 1L
      inputs[[calls]]
    }

    expect_identical(
      aFIPC:::.read_binary_choice(
        prompt = "confirm",
        failure_message = "too many invalid attempts",
        read_input = reader
      ),
      2L
    )
    expect_identical(calls, 2L)
  }
})

test_that("binary choice admission preserves the context-specific stop contract", {
  reader <- local({
    inputs <- c("3", "", "9999999999999999999")
    calls <- 0L
    function(prompt) {
      calls <<- calls + 1L
      inputs[[calls]]
    }
  })

  expect_error(
    aFIPC:::.read_binary_choice(
      prompt = "confirm",
      failure_message = "Too many invalid common item confirmation attempts",
      read_input = reader
    ),
    "Too many invalid common item confirmation attempts",
    fixed = TRUE
  )
})
