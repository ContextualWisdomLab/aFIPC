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
  raw$item11 <- 1

  fitted <- aFIPC::surveyFA(
    data = raw,
    autofix = TRUE,
    forceUIRT = TRUE,
    forceNormalEM = TRUE,
    SE = TRUE
  )

  fitted_vcov <- as.matrix(fitted@vcov)
  expect_true(inherits(fitted, "SingleGroupClass"))
  expect_gt(nrow(fitted_vcov), 0)
  expect_true(all(is.finite(diag(fitted_vcov))))
  expect_true(isTRUE(fitted@OptimInfo$secondordertest))
})

test_that("surveyFA errors clearly for unsupported input", {
  expect_error(
    aFIPC::surveyFA(1:10, forceUIRT = TRUE),
    "surveyFA requires a response matrix or data frame"
  )
})

test_that("surveyFA validates boolean control flags before estimator dispatch", {
  raw <- data.frame(
    item1 = c(0, 1, 0, 1),
    item2 = c(1, 0, 1, 0)
  )

  expect_error(
    aFIPC::surveyFA(raw, autofix = c(TRUE, FALSE)),
    "Security Error: autofix must be a single non-NA logical value"
  )
  expect_error(
    aFIPC::surveyFA(raw, forceNormalEM = NA),
    "Security Error: forceNormalEM must be a single non-NA logical value"
  )
  expect_error(
    aFIPC::surveyFA(raw, SE = "TRUE"),
    "Security Error: SE must be a single non-NA logical value"
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

test_that("surveyFA input validation errors", {
  dat <- data.frame(a=c(1,0,1), b=c(0,1,1))
  expect_error(surveyFA(data=dat, autofix="TRUE"), "Security Error: autofix must be a single non-NA logical value")
  expect_error(surveyFA(data=dat, forceUIRT=FALSE), "surveyFA requires forceUIRT=TRUE")
  expect_error(surveyFA(data=123), "surveyFA requires a response matrix or data frame")
  expect_error(surveyFA(data=dat, itemtype=123), "surveyFA requires itemtype to be a single non-NA character value")
  expect_error(surveyFA(data=dat, maxItemRemovals="3"), "surveyFA requires maxItemRemovals to be a non-negative numeric scalar")
  expect_error(surveyFA(data=dat, pThreshold=2), "surveyFA requires pThreshold to be in \\(0, 1\\]")
})

test_that("surveyFA method fallbacks", {
  dat <- data.frame(a=c(1,0,1,0), b=c(0,1,1,1), c=c(0,0,1,1))

  mock_mirt <- function(data, model, itemtype, SE, GenRandomPars, method, technical, empiricalhist=FALSE) {
    if (method == "QMCEM") stop("Forced QMCEM error")
    if (method == "MHRM") stop("Forced MHRM error")
    if (method == "EM") {
       mod <- new("SingleGroupClass")
       mod@OptimInfo$converged <- TRUE
       mod@Fit$logLik <- -100
       mod@OptimInfo$secondordertest <- TRUE
       mod@vcov <- matrix(1, 3, 3)
       return(mod)
    }
  }

  testthat::local_mocked_bindings(mirt = mock_mirt, .package = "mirt")

  # When forceNormalEM = TRUE, it tries EM first and succeeds.
  suppressWarnings(res <- surveyFA(dat, forceNormalEM = TRUE, SE = TRUE))
  expect_true(inherits(res, "SingleGroupClass"))

  # When unstable = TRUE, it tries QMCEM (fails), MHRM (fails), EM (succeeds)
  suppressWarnings(res2 <- surveyFA(dat, unstable = TRUE, SE = TRUE))
  expect_true(inherits(res2, "SingleGroupClass"))

  # Test autofix branch where EM fails and we need to drop items
  mock_mirt_fail <- function(...) { stop("All fail") }
  mock_itemfit <- function(...) { data.frame(p.value=c(0.01, 0.5, 0.5), row.names=c("a","b","c")) }

  testthat::local_mocked_bindings(mirt = mock_mirt_fail, .package = "mirt")
  testthat::local_mocked_bindings(itemfit = mock_itemfit, .package = "mirt")

  expect_error(suppressWarnings(surveyFA(dat, maxItemRemovals=1)), "surveyFA fallback could not estimate a valid model")
})
