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

test_that("surveyFA properly triggers fallback when autofix is disabled and covers item removal", {
  skip_if_not_installed("mirt")
  set.seed(20260702)

  # Intentionally messy data to force failure on standard methods
  raw <- as.data.frame(
    matrix(
      c(rep(1, 20), rep(0, 20), rbinom(160, 1, 0.5)),
      ncol = 5
    )
  )
  names(raw) <- paste0("item", 1:5)
  raw$item6 <- 0 # Constant column

  # Force failure without autofix
  expect_error(
    suppressWarnings(
      aFIPC::surveyFA(
        data = raw,
        autofix = FALSE,
        forceUIRT = TRUE,
        forceNormalEM = FALSE,
        forceMHRM = TRUE, # Cover forceMHRM branch
        unstable = FALSE,
        SE = TRUE,
        itemtype = "2PL",
        maxItemRemovals = 2
      )
    ),
    "could not estimate a valid model after bounded recovery attempts"
  )

  # Trigger unstable branch and force NormalEM=FALSE
  expect_error(
     suppressWarnings(
        aFIPC::surveyFA(
          data = raw,
          autofix = TRUE,
          forceUIRT = TRUE,
          forceNormalEM = FALSE,
          forceMHRM = FALSE,
          unstable = FALSE,
          SE = TRUE,
          itemtype = "2PL",
          maxItemRemovals = 2
        )
      ),
      "could not estimate a valid model after bounded recovery attempts"
  )

  # Trigger legacy forceUIRT warning
  expect_error(
    aFIPC::surveyFA(data=raw, forceUIRT = FALSE),
    "surveyFA requires forceUIRT=TRUE"
  )

  # Check invalid itemtype
  expect_error(
    aFIPC::surveyFA(data=raw, itemtype = c("2PL", "3PL")),
    "surveyFA requires itemtype to be a single non-NA character value"
  )

  # Check invalid maxItemRemovals
  expect_error(
    aFIPC::surveyFA(data=raw, maxItemRemovals = -1),
    "surveyFA requires maxItemRemovals to be a non-negative numeric scalar"
  )

  # Check invalid pThreshold
  expect_error(
    aFIPC::surveyFA(data=raw, pThreshold = 1.5),
    "surveyFA requires pThreshold to be in \\(0, 1\\]"
  )

  # Check insufficient non-constant columns
  bad_raw <- data.frame(item1 = rep(1, 10), item2 = rep(2, 10))
  expect_error(
    aFIPC::surveyFA(bad_raw, forceUIRT=TRUE),
    "surveyFA needs at least two non-constant response columns"
  )
})
