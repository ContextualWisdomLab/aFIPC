make_binary_reader <- function(values) {
  next_value <- 0L
  function(prompt) {
    next_value <<- next_value + 1L
    values[[next_value]]
  }
}

test_that("binary choice reader accepts only the documented values", {
  expect_identical(
    aFIPC:::.read_binary_choice(
      prompt = "choice: ",
      reader = make_binary_reader("1"),
      exhausted_message = "exhausted"
    ),
    1L
  )
  expect_identical(
    aFIPC:::.read_binary_choice(
      prompt = "choice: ",
      reader = make_binary_reader("2"),
      exhausted_message = "exhausted"
    ),
    2L
  )
})

test_that("binary choice reader retries oversized and unsupported input", {
  result <- aFIPC:::.read_binary_choice(
    prompt = "choice: ",
    reader = make_binary_reader(c("999999999999999999999", "0", "2")),
    exhausted_message = "exhausted"
  )

  expect_identical(result, 2L)
})

test_that("binary choice reader fails after three invalid attempts", {
  expect_error(
    aFIPC:::.read_binary_choice(
      prompt = "choice: ",
      reader = make_binary_reader(c("999999999999999999999", "0", "3")),
      exhausted_message = "bounded retry exhausted"
    ),
    "bounded retry exhausted",
    fixed = TRUE
  )
})
