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

find_prior_assignment_block <- function(expression, function_name, target_name) {
  if (!is.call(expression)) {
    return(NULL)
  }

  if (identical(expression[[1L]], as.name("if")) && length(expression) >= 3L) {
    body_expr <- expression[[3L]]

    if (is.call(body_expr) && identical(body_expr[[1L]], as.name("{"))) {
        for (i in seq_len(length(body_expr))) {
            stmt <- body_expr[[i]]
            if (is.call(stmt) && identical(stmt[[1L]], as.name("<-")) && identical(stmt[[2L]], as.name(target_name))) {
                if (is.call(stmt[[3L]]) && identical(stmt[[3L]][[1L]], as.name(function_name))) {
                    new_block <- substitute({
                        check_fn <- function() {}
                        target <- check_fn()
                    }, list(target = as.name(target_name), check_fn = as.name(function_name)))

                    for (j in seq_len(length(body_expr))) {
                        if (is.call(body_expr[[j]]) && identical(body_expr[[j]][[1L]], as.name("<-")) && identical(body_expr[[j]][[2L]], as.name(function_name))) {
                            new_block[[2L]] <- body_expr[[j]]
                        }
                        if (is.call(body_expr[[j]]) && identical(body_expr[[j]][[1L]], as.name("<-")) && identical(body_expr[[j]][[2L]], as.name(target_name))) {
                            new_block[[3L]] <- body_expr[[j]]
                        }
                        if (is.call(body_expr[[j]]) && identical(body_expr[[j]][[1L]], as.name("if")) && is.call(body_expr[[j]][[2L]]) && identical(body_expr[[j]][[2L]][[2L]], as.name(target_name))) {
                            if_block <- body_expr[[j]]
                            new_block[[4L]] <- substitute(if (!is.null(target)) if_block, list(target=as.name(target_name), if_block=if_block))
                        }
                    }

                    return(new_block)
                }
            }
        }
    }
  }

  for (part in as.list(expression)[-1L]) {
    nested <- find_prior_assignment_block(part, function_name, target_name)
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

scripted_prior_assignment <- function(function_name, target_name, value) {
  assignment_block <- find_prior_assignment_block(
    body(aFIPC::autoFIPC),
    function_name,
    target_name
  )
  if (is.null(assignment_block)) {
    stop(sprintf("Could not find assignment block for %s", function_name))
  }

  index <- 0L
  test_env <- new.env(parent = environment(aFIPC::autoFIPC))
  test_env$itemtype <- "3PL"
  test_env[[target_name]] <- NULL
  test_env$interactive <- function() TRUE
  test_env$readline <- function(prompt = "") {
    index <<- index + 1L
    value
  }

  eval(assignment_block, envir = test_env)

  list(
    value = test_env[[target_name]],
    reads = index
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

test_that("common-item exact choices drive reject or proceed behavior", {
  reject_runner <- scripted_auto_fipc("2")
  expect_error(
    reject_runner$run(
      newformXData = data.frame(A = c(0, 1)),
      oldformYData = data.frame(A = c(0, 1)),
      newformCommonItemNames = "A",
      oldformCommonItemNames = "A"
    ),
    "Please write down pairs correctly",
    fixed = TRUE
  )
  expect_identical(reject_runner$reads(), 1L)

  huge_integer <- paste(rep("9", 1000), collapse = "")
  proceed_runner <- scripted_auto_fipc(c("1", "0", "+1", huge_integer))
  expect_error(
    proceed_runner$run(
      newformXData = data.frame(A = c(0, 1)),
      oldformYData = data.frame(A = c(0, 1)),
      newformCommonItemNames = "A",
      oldformCommonItemNames = "A"
    ),
    "Too many invalid oldform BILOG prior attempts",
    fixed = TRUE
  )
  expect_identical(proceed_runner$reads(), 4L)
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

test_that("old-form and new-form choices set their logical prior flags", {
  old_yes <- scripted_prior_assignment(
    "checkoldformBILOGprior",
    "oldformBILOGprior",
    "1"
  )
  old_no <- scripted_prior_assignment(
    "checkoldformBILOGprior",
    "oldformBILOGprior",
    "2"
  )
  new_yes <- scripted_prior_assignment(
    "checknewformBILOGprior",
    "newformBILOGprior",
    "1"
  )
  new_no <- scripted_prior_assignment(
    "checknewformBILOGprior",
    "newformBILOGprior",
    "2"
  )

  expect_identical(old_yes$value, TRUE)
  expect_identical(old_no$value, FALSE)
  expect_identical(new_yes$value, TRUE)
  expect_identical(new_no$value, FALSE)
  expect_identical(old_yes$reads, 1L)
  expect_identical(old_no$reads, 1L)
  expect_identical(new_yes$reads, 1L)
  expect_identical(new_no$reads, 1L)
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
