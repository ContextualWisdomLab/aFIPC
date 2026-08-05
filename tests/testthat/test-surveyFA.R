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

test_that("minimum named selection preserves prior sort semantics", {
  normalized_cases <- list(
    c(item_a = 0.40, item_b = 0.10, item_c = 0.30),
    c(item_a = 0.10, item_b = 0.10, item_c = 0.20),
    c(item_a = 1.00, item_b = 0.20, item_c = 1.00),
    c(item_a = -0.50, item_b = 0.00, item_c = 0.50)
  )

  for (p_values in normalized_cases) {
    prior_candidate <- names(sort(p_values, decreasing = FALSE))[1L]
    expect_identical(
      aFIPC:::.minimum_named_value(p_values),
      prior_candidate
    )
  }
  expect_identical(
    aFIPC:::.minimum_named_value(setNames(numeric(), character())),
    NA_character_
  )
})

test_that("surveyFA reports bounded recovery exhaustion when unrecoverable", {
  skip_if_not_installed("mirt")
  set.seed(20260726)

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

test_that("surveyFA removes the minimum-variance binary item", {
  skip_if_not_installed("mirt")
  set.seed(20260727)

  raw <- as.data.frame(
    mirt::simdata(
      a = matrix(c(1.00, 1.20, 0.95), ncol = 1),
      d = c(-1.0, -0.45, -0.10),
      itemtype = rep("2PL", 3),
      N = 100
    )
  )
  names(raw) <- c("item1", "item2", "item3")

  # Keep the 2PL input binary while making item3 the deterministic variance minimum.
  raw$item3 <- rep(0L, nrow(raw))
  raw$item3[1:3] <- 1L

  expect_error(
    suppressWarnings(
      aFIPC::surveyFA(
        data = raw,
        autofix = TRUE,
        forceUIRT = TRUE,
        itemtype = "2PL",
        maxItemRemovals = 1,
        forceNormalEM = TRUE,
        SE = TRUE,
        pThreshold = 0.000000001
      )
    ),
    "could not estimate a valid model after bounded recovery attempts.*Removed items: item3"
  )
})
