test_that("surveyFA can recover with bounded autofix for messy response data", {
  skip_if_not_installed("mirt")
  set.seed(20260702)

  raw <- as.data.frame(
    mirt::simdata(
      a = matrix(c(
        1.00, 1.20, 0.95, 1.08, 1.12,
        0.90, 1.05, 1.18, 1.22, 0.88
      ), ncol = 1),
      d = c(-1.0, -0.45, -0.10, 0.30, 0.70, -0.65, 0.20, 0.55, 0.95, -0.30),
      itemtype = rep("2PL", 10),
      N = 200
    )
  )
  names(raw) <- paste0("item", seq_len(ncol(raw)))
  # include one constant column to exercise bounded cleanup behavior
  raw$item11 <- 1

  fitted <- aFIPC::surveyFA(
    data = raw,
    autofix = TRUE,
    forceUIRT = TRUE,
    forceNormalEM = TRUE,
    SE = FALSE
  )

  expect_true(inherits(fitted, "SingleGroupClass"))
  expect_true(fitted@OptimInfo$secondordertest)
})

test_that("surveyFA errors clearly for unsupported input", {
  skip_if_not_installed("mirt")

  expect_error(
    aFIPC::surveyFA(1:10, forceUIRT = TRUE),
    "surveyFA requires a response matrix or data frame"
  )
})

test_that("surveyFA reports bounded recovery exhaustion when unrecoverable", {
  skip_if_not_installed("mirt")

  raw <- as.data.frame(
    matrix(
      c(rbinom(80, 1, 0.5), rbinom(80, 1, 0.4)),
      ncol = 2
    )
  )
  names(raw) <- paste0("item", 1:2)

  expect_error(
    suppressWarnings(
      aFIPC::surveyFA(
        data = raw,
        autofix = TRUE,
        forceUIRT = TRUE,
        itemtype = "not_a_model",
        maxItemRemovals = 1
      )
    ),
    "could not estimate a valid model after bounded recovery attempts"
  )
})
