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

find_nested_function_expression <- function(expression, function_name) {
  if (!is.call(expression)) {
    return(NULL)
  }

  if (
    length(expression) >= 3L &&
      identical(expression[[1L]], as.name("<-")) &&
      identical(expression[[2L]], as.name(function_name)) &&
      is.call(expression[[3L]]) &&
      identical(expression[[3L]][[1L]], as.name("function"))
  ) {
    return(expression[[3L]])
  }

  for (part in as.list(expression)[-1L]) {
    nested <- find_nested_function_expression(part, function_name)
    if (!is.null(nested)) {
      return(nested)
    }
  }

  NULL
}

scripted_nested_prompt <- function(function_name, values, confirm_common_items = NULL) {
  function_expression <- find_nested_function_expression(
    body(aFIPC::autoFIPC),
    function_name
  )
  if (is.null(function_expression)) {
    stop(sprintf("Could not find nested prompt helper %s", function_name))
  }

  index <- 0L
  test_env <- new.env(parent = environment(aFIPC::autoFIPC))
  test_env$confirmCommonItems <- confirm_common_items
  test_env$interactive <- function() TRUE
  test_env$readline <- function(prompt = "") {
    index <<- index + 1L
    values[[min(index, length(values))]]
  }

  list(
    run = eval(function_expression, envir = test_env),
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

test_that("all three prompt helpers accept only the exact binary choices", {
  helper_names <- c(
    "checkCorrect",
    "checkoldformBILOGprior",
    "checknewformBILOGprior"
  )

  for (helper_name in helper_names) {
    yes_runner <- scripted_nested_prompt(helper_name, "1")
    expect_identical(
      yes_runner$run(),
      1L,
      info = sprintf("%s should accept exact choice 1", helper_name)
    )
    expect_identical(yes_runner$reads(), 1L)

    no_runner <- scripted_nested_prompt(helper_name, "2")
    expect_identical(
      no_runner$run(),
      2L,
      info = sprintf("%s should accept exact choice 2", helper_name)
    )
    expect_identical(no_runner$reads(), 1L)
  }
})

test_that("common-item helper maps accepted choices to proceed or reject", {
  yes_runner <- scripted_nested_prompt("checkCorrect", "1")
  no_runner <- scripted_nested_prompt("checkCorrect", "2")

  expect_identical(yes_runner$run(), 1L)
  expect_identical(no_runner$run(), 2L)
})

test_that("new-form prior prompt rejects representative invalid choices", {
  huge_integer <- paste(rep("9", 1000), collapse = "")
  runner <- scripted_nested_prompt(
    "checknewformBILOGprior",
    c("0", " 2", huge_integer)
  )

  expect_error(
    runner$run(),
    "Too many invalid newform BILOG prior attempts",
    fixed = TRUE
  )
  expect_identical(runner$reads(), 3L)
})
