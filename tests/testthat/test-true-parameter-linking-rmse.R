# True-parameter linking RMSE / recovery (buyer-visible quality gate).
#
# Existing fixtures pin the Kim (2006) FIPC *contract* (anchors copied and
# held fixed). They do not report recovery error of free new-form items
# against the generating parameters. This file adds that metric.
#
# Scale: simdata() defaults to N(0, 1) theta. autoFIPC() is called with
# forceNormalZeroOne = TRUE and freeMEAN = FALSE so the linked unique items
# stay on that same metric. Anchors are fixed to *estimated* old-form
# values, so unique-item RMSE versus truth includes ordinary calibration
# error plus the small scale discrepancy of those estimated anchors.
#
# This package still orchestrates FIPC in R and delegates estimation to
# mirt (Chalmers, 2012; Bock & Aitkin, 1981). There is no Rust or GPU
# numeric core; this test is the recovery gate, not a new estimator.
#
# References (APA 7th):
#   Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood
#     estimation of item parameters: Application of an EM algorithm.
#     Psychometrika, 46(4), 443-459. https://doi.org/10.1007/BF02293801
#   Chalmers, R. P. (2012). mirt: A multidimensional item response theory
#     package for the R environment. Journal of Statistical Software,
#     48(6), 1-29. https://doi.org/10.18637/jss.v048.i06
#   Kim, S. (2006). A comparative study of IRT fixed parameter calibration
#     methods. Journal of Educational Measurement, 43(4), 355-381.
#     https://doi.org/10.1111/j.1745-3984.2006.00021.x

rmse <- function(est, tru) {
  sqrt(mean((as.numeric(est) - as.numeric(tru))^2))
}

item_ad_values <- function(vals, items) {
  out <- numeric(0)
  for (it in items) {
    row <- vals[vals$item == it & vals$name %in% c("a1", "d"), c("name", "value")]
    row <- row[match(c("a1", "d"), row$name), ]
    out <- c(out, row$value)
  }
  out
}

item_ad_truth <- function(a, d, idx) {
  as.numeric(rbind(a[idx, 1], d[idx]))
}

test_that("FIPC recovers generating parameters at bounded RMSE", {
  skip_on_cran()
  skip_if_not_installed("mirt")

  set.seed(20260817)
  old_item_names <- paste0("old_", 1:8)
  new_item_names <- paste0("new_", 1:8)
  old_common_items <- old_item_names[1:5]
  new_common_items <- new_item_names[1:5]
  unique_idx <- 6:8

  common_a <- c(0.90, 1.15, 1.30, 0.80, 1.05)
  common_d <- c(-1.00, -0.35, 0.20, 0.80, -0.50)
  old_a <- matrix(c(common_a, 0.85, 1.20, 0.70), ncol = 1)
  old_d <- c(common_d, 0.40, -0.65, 0.25)
  new_a <- matrix(c(common_a, 1.10, 0.85, 1.25), ncol = 1)
  new_d <- c(common_d, -0.15, 0.55, -0.40)

  old_data <- as.data.frame(mirt::simdata(
    a = old_a,
    d = old_d,
    itemtype = rep("2PL", length(old_item_names)),
    N = 2000
  ))
  new_data <- as.data.frame(mirt::simdata(
    a = new_a,
    d = new_d,
    itemtype = rep("2PL", length(new_item_names)),
    N = 2000
  ))
  names(old_data) <- old_item_names
  names(new_data) <- new_item_names

  old_model <- mirt::mirt(
    old_data,
    1,
    itemtype = "2PL",
    method = "EM",
    verbose = FALSE,
    technical = list(NCYCLES = 500)
  )
  new_model <- mirt::mirt(
    new_data,
    1,
    itemtype = "2PL",
    method = "EM",
    verbose = FALSE,
    technical = list(NCYCLES = 500)
  )

  linked <- aFIPC::autoFIPC(
    newformXData = new_model,
    oldformYData = old_model,
    newformCommonItemNames = new_common_items,
    oldformCommonItemNames = old_common_items,
    itemtype = "2PL",
    checkIPD = FALSE,
    tryEM = TRUE,
    freeMEAN = FALSE,
    forceNormalZeroOne = TRUE,
    confirmCommonItems = TRUE
  )

  old_values <- mirt::mod2values(old_model)
  linked_values <- mirt::mod2values(linked$LinkedModel)

  old_anchor_est <- item_ad_values(old_values, old_common_items)
  linked_anchor_est <- item_ad_values(linked_values, new_common_items)
  anchor_copy_rmse <- rmse(linked_anchor_est, old_anchor_est)

  old_recovery_rmse <- rmse(
    old_anchor_est,
    item_ad_truth(old_a, old_d, seq_along(old_common_items))
  )

  unique_linked_est <- item_ad_values(linked_values, new_item_names[unique_idx])
  unique_linked_rmse <- rmse(
    unique_linked_est,
    item_ad_truth(new_a, new_d, unique_idx)
  )

  # testthat 3 expect_lt() has no info=; keep every gate on expect_true()
  # so CI logs always print the three RMSE numbers.
  metrics <- sprintf(
    "anchor_copy_rmse=%.6f old_recovery_rmse=%.4f unique_linked_rmse=%.4f",
    anchor_copy_rmse,
    old_recovery_rmse,
    unique_linked_rmse
  )
  expect_true(
    is.finite(anchor_copy_rmse) &&
      is.finite(old_recovery_rmse) &&
      is.finite(unique_linked_rmse),
    info = metrics
  )
  expect_true(anchor_copy_rmse < 1e-6, info = metrics)
  expect_true(old_recovery_rmse < 0.40, info = metrics)
  expect_true(unique_linked_rmse < 0.50, info = metrics)
})
