test_that("autoFIPC raises error in non-interactive session for inputs", {
  # interactive() should be FALSE by default in testthat environments
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Common item confirmation requires an interactive session"
  )
})

test_that("autoFIPC does not implicitly approve supplied common items", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = FALSE
    ),
    "Please write down pairs correctly"
  )
})

test_that("autoFIPC validates input types securely", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = 1,
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Security Error: newformXData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = 123,
      oldformCommonItemNames = c('A')
    ),
    "Security Error: newformCommonItemNames must be a character vector"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = c("3PL", "2PL")
    ),
    "Security Error: itemtype must be length 1 or length 1 \\(number of items\\)."
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = structure(list(), class = "SingleGroupClass"),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE
    ),
    "Security Error: oldformYData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryFitwholeNewItems = "TRUE"
    ),
    "Security Error: tryFitwholeNewItems must be a single non-NA logical value"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryEM = NA
    ),
    "Security Error: tryEM must be a single non-NA logical value"
  )
})

.find_local_function_expression <- function(node, local_name) {
  if (
    is.call(node) &&
      length(node) >= 3L &&
      identical(node[[1L]], as.name("<-")) &&
      identical(node[[2L]], as.name(local_name)) &&
      is.call(node[[3L]]) &&
      identical(node[[3L]][[1L]], as.name("function"))
  ) {
    return(node[[3L]])
  }

  if (!is.recursive(node)) {
    return(NULL)
  }

  for (child in as.list(node)) {
    found <- .find_local_function_expression(child, local_name)
    if (!is.null(found)) {
      return(found)
    }
  }

  NULL
}

.extract_prompt_function <- function(local_name, bindings) {
  expression <- .find_local_function_expression(
    body(aFIPC::autoFIPC),
    local_name
  )
  if (is.null(expression)) {
    stop(sprintf("Could not find local prompt function %s", local_name))
  }

  eval(expression, envir = list2env(bindings, parent = baseenv()))
}

.scripted_reader <- function(values) {
  index <- 0L
  force(values)

  function(prompt = "") {
    index <<- index + 1L
    if (index > length(values)) {
      stop("scripted reader exhausted")
    }
    values[[index]]
  }
}

test_that("all interactive choice prompts accept only exact 1 or 2", {
  prompt_contracts <- list(
    list(
      name = "checkCorrect",
      error = "Too many invalid common item confirmation attempts",
      extra = list(confirmCommonItems = NULL)
    ),
    list(
      name = "checkoldformBILOGprior",
      error = "Too many invalid oldform BILOG prior attempts",
      extra = list()
    ),
    list(
      name = "checknewformBILOGprior",
      error = "Too many invalid newform BILOG prior attempts",
      extra = list()
    )
  )

  invalid_inputs <- c(
    "0",
    "12",
    paste(rep("9", 1000L), collapse = ""),
    " ",
    "x"
  )

  for (contract in prompt_contracts) {
    for (choice in c("1", "2")) {
      prompt_function <- .extract_prompt_function(
        contract$name,
        c(
          contract$extra,
          list(
            interactive = function() TRUE,
            readline = .scripted_reader(choice)
          )
        )
      )
      expect_identical(
        prompt_function(),
        as.integer(choice),
        info = sprintf("%s should accept %s", contract$name, choice)
      )
    }

    for (invalid_input in invalid_inputs) {
      prompt_function <- .extract_prompt_function(
        contract$name,
        c(
          contract$extra,
          list(
            interactive = function() TRUE,
            readline = .scripted_reader(rep(invalid_input, 3L))
          )
        )
      )
      expect_error(
        prompt_function(),
        contract$error,
        info = sprintf(
          "%s should reject %s for all three attempts",
          contract$name,
          encodeString(invalid_input)
        )
      )
    }
  }
})
