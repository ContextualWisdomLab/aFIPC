test_that("autoFIPC validates boolean flags for newformBILOGprior, oldformBILOGprior, and confirmCommonItems", {
  # newformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      newformBILOGprior = "TRUE"
    ),
    "Security Error: newformBILOGprior must be a single non-NA logical value or NULL"
  )

  # oldformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      oldformBILOGprior = c(TRUE, FALSE)
    ),
    "Security Error: oldformBILOGprior must be a single non-NA logical value or NULL"
  )

  # confirmCommonItems
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NA
    ),
    "Security Error: confirmCommonItems must be a single non-NA logical value or NULL"
  )
})


test_that("binary menu choice accepts only exact documented values", {
  make_reader <- function(values) {
    force(values)
    function(prompt) {
      value <- values[[1]]
      values <<- values[-1]
      value
    }
  }

  expect_identical(
    aFIPC:::.read_binary_choice("prompt", "invalid", make_reader("1")),
    1L
  )
  expect_identical(
    aFIPC:::.read_binary_choice("prompt", "invalid", make_reader("2")),
    2L
  )
  expect_identical(
    aFIPC:::.read_binary_choice(
      "prompt",
      "invalid",
      make_reader(c("0", "3", "1"))
    ),
    1L
  )
  expect_error(
    aFIPC:::.read_binary_choice(
      "prompt",
      "invalid",
      make_reader(c("12", "2147483648", " 1"))
    ),
    "invalid",
    fixed = TRUE
  )

  for (value in c("3", "10", "2147483648", "invalid", "")) {
    expect_error(
      aFIPC:::.read_binary_choice(
        "prompt",
        "invalid",
        make_reader(rep(value, 3))
      ),
      "invalid",
      fixed = TRUE,
      info = paste("unexpectedly accepted binary menu value", dQuote(value))
    )
  }
})

test_that("autoFIPC routes every interactive binary menu through the bounded reader", {
  source_text <- paste(deparse(body(aFIPC::autoFIPC)), collapse = "\n")
  calls <- gregexpr(".read_binary_choice(", source_text, fixed = TRUE)[[1]]

  expect_equal(sum(calls > 0), 3L)
  expect_false(grepl('grepl("^[0-9]+$"', source_text, fixed = TRUE))
  expect_match(source_text, "Too many invalid common item confirmation attempts", fixed = TRUE)
  expect_match(source_text, "Too many invalid oldform BILOG prior attempts", fixed = TRUE)
  expect_match(source_text, "Too many invalid newform BILOG prior attempts", fixed = TRUE)
})

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

  if (identical(expression[[1L]], as.name("if"))) {
    expression_text <- paste(deparse(expression), collapse = "\n")
    assignment_text <- sprintf("%s <- %s()", target_name, function_name)
    if (
      grepl(function_name, expression_text, fixed = TRUE) &&
        grepl(assignment_text, expression_text, fixed = TRUE)
    ) {
      return(expression)
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

wired_prompt <- function(function_name, choice, confirm_common_items = NULL) {
  function_expression <- find_nested_function_expression(
    body(aFIPC::autoFIPC),
    function_name
  )
  if (is.null(function_expression)) {
    stop(sprintf("Could not find nested prompt helper %s", function_name))
  }

  calls <- 0L
  test_env <- new.env(parent = environment(aFIPC::autoFIPC))
  test_env$confirmCommonItems <- confirm_common_items
  test_env$interactive <- function() TRUE
  test_env$.read_binary_choice <- function(prompt, error_message) {
    calls <<- calls + 1L
    choice
  }

  list(
    run = eval(function_expression, envir = test_env),
    calls = function() calls
  )
}

wired_prior_assignment <- function(function_name, target_name, choice) {
  assignment_block <- find_prior_assignment_block(
    body(aFIPC::autoFIPC),
    function_name,
    target_name
  )
  if (is.null(assignment_block)) {
    stop(sprintf("Could not find assignment block for %s", function_name))
  }

  calls <- 0L
  test_env <- new.env(parent = environment(aFIPC::autoFIPC))
  test_env$itemtype <- "3PL"
  test_env[[target_name]] <- NULL
  test_env$interactive <- function() TRUE
  test_env$.read_binary_choice <- function(prompt, error_message) {
    calls <<- calls + 1L
    choice
  }

  eval(assignment_block, envir = test_env)

  list(
    value = test_env[[target_name]],
    calls = calls
  )
}

test_that("all three autoFIPC prompt helpers execute the shared bounded reader", {
  helper_names <- c(
    "checkCorrect",
    "checkoldformBILOGprior",
    "checknewformBILOGprior"
  )

  for (helper_name in helper_names) {
    yes_runner <- wired_prompt(helper_name, 1L)
    expect_identical(
      yes_runner$run(),
      1L,
      info = sprintf("%s should return shared-reader choice 1", helper_name)
    )
    expect_identical(yes_runner$calls(), 1L)

    no_runner <- wired_prompt(helper_name, 2L)
    expect_identical(
      no_runner$run(),
      2L,
      info = sprintf("%s should return shared-reader choice 2", helper_name)
    )
    expect_identical(no_runner$calls(), 1L)
  }
})

test_that("old-form and new-form bounded choices map to logical prior flags", {
  old_yes <- wired_prior_assignment(
    "checkoldformBILOGprior",
    "oldformBILOGprior",
    1L
  )
  old_no <- wired_prior_assignment(
    "checkoldformBILOGprior",
    "oldformBILOGprior",
    2L
  )
  new_yes <- wired_prior_assignment(
    "checknewformBILOGprior",
    "newformBILOGprior",
    1L
  )
  new_no <- wired_prior_assignment(
    "checknewformBILOGprior",
    "newformBILOGprior",
    2L
  )

  expect_identical(old_yes$value, TRUE)
  expect_identical(old_no$value, FALSE)
  expect_identical(new_yes$value, TRUE)
  expect_identical(new_no$value, FALSE)
  expect_identical(old_yes$calls, 1L)
  expect_identical(old_no$calls, 1L)
  expect_identical(new_yes$calls, 1L)
  expect_identical(new_no$calls, 1L)
})
