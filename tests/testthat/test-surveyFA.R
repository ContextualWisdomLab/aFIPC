test_that("surveyFA can recover with bounded autofix for messy response data", {
  skip_if_not_installed("mirt")
  set.seed(20260702)

  raw <- as.data.frame(
    matrix(
      c(
        rbinom(200, 1, 0.65),
        rbinom(200, 1, 0.55),
        rep(1, 200)
      ),
      ncol = 3
    )
  )
  names(raw) <- paste0("item", 1:3)

  fitted <- aFIPC::surveyFA(
    data = raw,
    autofix = TRUE,
    forceUIRT = TRUE,
    SE = FALSE
  )

  expect_s3_class(fitted, "SingleGroupClass")
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
    aFIPC::surveyFA(
      data = raw,
      autofix = TRUE,
      forceUIRT = TRUE,
      itemtype = "not_a_model",
      maxItemRemovals = 1
    ),
    "could not estimate a valid model after bounded recovery attempts"
  )
})
