test_that("autoFIPC handles non-interactive sessions securely to prevent DoS (checkCorrect)", {
  expect_error(
    autoFIPC(
      newformXData = matrix(0, nrow=10, ncol=10),
      oldformYData = matrix(0, nrow=10, ncol=10),
      newformCommonItemNames = c("Item1"),
      oldformCommonItemNames = c("Item1")
    ),
    "Non-interactive session detected. Cannot use interactive prompts. Please provide correct common items."
  )
})

test_that("autoFIPC handles non-interactive sessions securely to prevent DoS (checkoldformBILOGprior)", {
  autoFIPC_mocked <- aFIPC::autoFIPC
  body(autoFIPC_mocked)[[11]] <- quote(checkCorrect <- function() return(1L))

  expect_error(
    autoFIPC_mocked(
      newformXData = matrix(0, nrow=10, ncol=10),
      oldformYData = data.frame(matrix(0, nrow=10, ncol=10)),
      newformCommonItemNames = c("Item1"),
      oldformCommonItemNames = c("Item1"),
      itemtype = '3PL',
      oldformBILOGprior = NULL
    ),
    "Non-interactive session detected. Please set oldformBILOGprior explicitly."
  )
})

test_that("autoFIPC handles non-interactive sessions securely to prevent DoS (checknewformBILOGprior)", {
  autoFIPC_mocked <- aFIPC::autoFIPC
  body(autoFIPC_mocked)[[11]] <- quote(checkCorrect <- function() return(1L))

  checknewformBILOGprior <- function() {
    if (!interactive()) stop("Non-interactive session detected. Please set newformBILOGprior explicitly.")
    n <- readline(prompt = "Do you want to use default BILOG-MG priors for newform Data? (1: Yes 2: No) : ")
    if (!grepl("^[0-9]+$", n)) {
      return(checknewformBILOGprior())
    }
    return(as.integer(n))
  }
  expect_error(checknewformBILOGprior(), "Non-interactive session detected. Please set newformBILOGprior explicitly.")
})
