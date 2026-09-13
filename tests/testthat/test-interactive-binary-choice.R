scripted_auto_fipc <- function(values) {
  index <- 0L
  fn <- aFIPC::autoFIPC
  test_env <- new.env(parent = environment(fn))
  test_env$interactive <- function() TRUE
  test_env$readline <- function(prompt = "") {
    index <<- index + 1L
    values[[min(index, length(values))]]
  }
  environment(fn) <- test_env

  list(
    run = fn,
    reads = function() index
  )
}

test_that("common-item confirmation rejects coercible and overflow choices", {
  huge_integer <- paste(rep("9", 1000), collapse = "")
  runner <- scripted_auto_fipc(c("3", " 1", huge_integer))

  expect_error(
    runner$run(
      newformXData = data.frame(A = c(0, 1)),
      oldformYData = data.frame(A = c(0, 1)),
      newformCommonItemNames = "A",
      oldformCommonItemNames = "A"
    ),
    "Too many invalid common item confirmation attempts",
    fixed = TRUE
  )
  expect_identical(runner$reads(), 3L)
})

test_that("old-form prior prompt uses the same exact binary-choice contract", {
  huge_integer <- paste(rep("9", 1000), collapse = "")
  runner <- scripted_auto_fipc(c("0", "+1", huge_integer))

  expect_error(
    runner$run(
      newformXData = data.frame(A = c(0, 1)),
      oldformYData = data.frame(A = c(0, 1)),
      newformCommonItemNames = "A",
      oldformCommonItemNames = "A",
      confirmCommonItems = TRUE
    ),
    "Too many invalid oldform BILOG prior attempts",
    fixed = TRUE
  )
  expect_identical(runner$reads(), 3L)
})

test_that("all three interactive binary prompts share exact 1-or-2 validation", {
  body_text <- paste(deparse(body(aFIPC::autoFIPC)), collapse = "\n")
  matches <- gregexpr('n %in% c("1", "2")', body_text, fixed = TRUE)[[1]]
  match_count <- if (identical(matches, -1L)) 0L else length(matches)

  expect_identical(match_count, 3L)
})
