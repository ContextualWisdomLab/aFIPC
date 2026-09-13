test_that("interactive binary choices accept only exact 1 or 2", {
  expect_identical(
    aFIPC:::read_binary_choice(
      prompt = "choice: ",
      noninteractive_error = "interactive required",
      invalid_error = "invalid choice",
      reader = function(prompt) "1",
      interactive_check = function() TRUE
    ),
    1L
  )

  expect_identical(
    aFIPC:::read_binary_choice(
      prompt = "choice: ",
      noninteractive_error = "interactive required",
      invalid_error = "invalid choice",
      reader = function(prompt) "2",
      interactive_check = function() TRUE
    ),
    2L
  )
})

test_that("interactive binary choices reject coercible and overflow inputs", {
  invalid_values <- c(
    "0", "3", "01", " 1", "1 ", "+1", "-1", "1.0",
    paste(rep("9", 1000), collapse = "")
  )
  index <- 0L

  expect_error(
    aFIPC:::read_binary_choice(
      prompt = "choice: ",
      noninteractive_error = "interactive required",
      invalid_error = "invalid choice",
      reader = function(prompt) {
        index <<- index + 1L
        invalid_values[index]
      },
      interactive_check = function() TRUE
    ),
    "invalid choice",
    fixed = TRUE
  )
  expect_identical(index, 3L)
})

test_that("interactive binary choices fail closed outside an interactive session", {
  reads <- 0L

  expect_error(
    aFIPC:::read_binary_choice(
      prompt = "choice: ",
      noninteractive_error = "interactive required",
      invalid_error = "invalid choice",
      reader = function(prompt) {
        reads <<- reads + 1L
        "1"
      },
      interactive_check = function() FALSE
    ),
    "interactive required",
    fixed = TRUE
  )
  expect_identical(reads, 0L)
})
