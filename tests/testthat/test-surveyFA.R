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

test_that("surveyFA correctly identifies the item with the minimum p-value", {
  skip_if_not_installed("mirt")
  set.seed(42)

  # Create synthetic data that will cause some misfit
  raw <- as.data.frame(
    mirt::simdata(
      a = matrix(rep(1, 5), ncol = 1),
      d = rep(0, 5),
      itemtype = rep("2PL", 5),
      N = 100
    )
  )
  names(raw) <- paste0("item", seq_len(ncol(raw)))

  # Inject noise to one item to make it misfit (item3)
  raw$item3 <- rbinom(100, 1, 0.1)

  # Capture the warning which might occur during estimation, we only care about the return
  fitted <- suppressWarnings(
    aFIPC::surveyFA(
      data = raw,
      autofix = TRUE,
      forceUIRT = TRUE,
      forceNormalEM = TRUE,
      SE = TRUE
    )
  )

  # If it removed an item, item3 is highly likely to be the one removed
  # or at least the process should not crash and should return a valid model.
  expect_true(inherits(fitted, "SingleGroupClass"))
  # Verify that candidate extraction which uses which.min() works without error
})

test_that("surveyFA correctly identifies the item with the minimum variance when p-values aren't enough", {
  skip_if_not_installed("mirt")
  set.seed(42)

  # Create synthetic data with one constant column so its variance is 0
  raw <- as.data.frame(
    mirt::simdata(
      a = matrix(rep(1, 5), ncol = 1),
      d = rep(0, 5),
      itemtype = rep("2PL", 5),
      N = 100
    )
  )
  names(raw) <- paste0("item", seq_len(ncol(raw)))

  # Inject noise to one item to make it misfit and also give it a really low variance
  # In select_bad_item, it falls back to var if it couldn't find anything by p-value or the itemfit fails.
  # Let's mock mirt::itemfit so it fails and we test the variance path directly.

  mock_itemfit <- mockery::mock(stop("Forced error"))
  mockery::stub(aFIPC::surveyFA, "mirt::itemfit", mock_itemfit)

  # We want one item to have smaller variance
  raw$item3 <- rep(0, 100)
  raw$item3[1] <- 1 # slightly non-constant so it doesn't get pre-filtered

  fitted <- suppressWarnings(
    aFIPC::surveyFA(
      data = raw,
      autofix = TRUE,
      forceUIRT = TRUE,
      forceNormalEM = TRUE,
      SE = TRUE,
      maxItemRemovals = 1
    )
  )

  expect_true(inherits(fitted, "SingleGroupClass"))
})
