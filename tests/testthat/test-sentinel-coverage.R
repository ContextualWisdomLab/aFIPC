run_common_item_confirmation <- function(answer) {
  f <- aFIPC::autoFIPC
  answers <- rep(answer, 3L)
  next_answer <- local({
    index <- 0L
    function() {
      index <<- index + 1L
      answers[[index]]
    }
  })

  test_scope <- new.env(parent = environment(f))
  test_scope$interactive <- function() TRUE
  test_scope$readline <- function(prompt = "") next_answer()
  environment(f) <- test_scope

  f(
    newformXData = matrix(c(0, 1), ncol = 1L),
    oldformYData = matrix(c(0, 1), ncol = 1L),
    newformCommonItemNames = "item_1",
    oldformCommonItemNames = "item_1"
  )
}

test_that("interactive confirmation accepts only the documented choices", {
  expect_error(
    run_common_item_confirmation("2"),
    "Please write down pairs correctly",
    fixed = TRUE
  )
  expect_error(
    run_common_item_confirmation("3"),
    "Too many invalid common item confirmation attempts",
    fixed = TRUE
  )
})

test_that("overflow-shaped interactive input is rejected before integer coercion", {
  huge_integer_text <- paste(rep("9", 4096L), collapse = "")

  expect_error(
    suppressWarnings(run_common_item_confirmation(huge_integer_text)),
    "Too many invalid common item confirmation attempts",
    fixed = TRUE
  )
})
