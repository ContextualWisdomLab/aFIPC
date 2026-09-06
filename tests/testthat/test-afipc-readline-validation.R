find_nested_function <- function(expr, target) {
  if (
    is.call(expr) &&
      identical(expr[[1]], as.name("<-")) &&
      identical(expr[[2]], as.name(target)) &&
      is.call(expr[[3]]) &&
      identical(expr[[3]][[1]], as.name("function"))
  ) {
    return(expr[[3]])
  }

  if (is.recursive(expr)) {
    for (part in as.list(expr)) {
      found <- find_nested_function(part, target)
      if (!is.null(found)) return(found)
    }
  }

  NULL
}

prompt_harness <- function(target, inputs) {
  function_expr <- find_nested_function(body(aFIPC::autoFIPC), target)
  expect_false(is.null(function_expr))

  calls <- 0L
  env <- new.env(parent = environment(aFIPC::autoFIPC))
  env$confirmCommonItems <- NULL
  env$interactive <- function() TRUE
  env$readline <- function(prompt) {
    calls <<- calls + 1L
    inputs[[calls]]
  }

  prompt_function <- eval(function_expr, envir = env)
  list(
    run = prompt_function,
    calls = function() calls
  )
}

prompt_contracts <- list(
  list(
    name = "checkCorrect",
    failure = "Too many invalid common item confirmation attempts"
  ),
  list(
    name = "checkoldformBILOGprior",
    failure = "Too many invalid oldform BILOG prior attempts"
  ),
  list(
    name = "checknewformBILOGprior",
    failure = "Too many invalid newform BILOG prior attempts"
  )
)

test_that("all interactive binary prompts reject out-of-range and oversized input before coercion", {
  for (contract in prompt_contracts) {
    harness <- prompt_harness(
      contract$name,
      c("3", "9999999999999999999", "1")
    )

    expect_warning(choice <- harness$run(), NA)
    expect_identical(choice, 1L)
    expect_identical(harness$calls(), 3L)
  }
})

test_that("all interactive binary prompts preserve exact-string admission", {
  for (contract in prompt_contracts) {
    for (invalid in c("3", " 1", "+1", "01", "9999999999999999999")) {
      harness <- prompt_harness(contract$name, c(invalid, "2"))

      expect_identical(harness$run(), 2L)
      expect_identical(harness$calls(), 2L)
    }

    expect_identical(prompt_harness(contract$name, "1")$run(), 1L)
    expect_identical(prompt_harness(contract$name, "2")$run(), 2L)
  }
})

test_that("all interactive binary prompts retain their context-specific retry failure", {
  for (contract in prompt_contracts) {
    harness <- prompt_harness(
      contract$name,
      c("3", "", "9999999999999999999")
    )

    expect_error(
      harness$run(),
      contract$failure,
      fixed = TRUE
    )
    expect_identical(harness$calls(), 3L)
  }
})
