# Directive item 2 — SE / Hessian / vcov / secondordertest preservation.
#
# When a mirt fit is requested with SE = TRUE, marginal maximum likelihood
# estimation (Bock & Aitkin, 1981) returns not only point estimates but also
# the observed-information matrix at the solution. mirt exposes its inverse as
# the parameter covariance matrix (vcov) and reports whether the estimate is a
# proper interior maximum via the second-order optimality test
# (extract.mirt(fit, "secondordertest")) — a positive-definite information
# matrix at the optimum (Cai, 2010, for the MH-RM standard-error machinery that
# generalizes this to high dimensions). aFIPC must not degrade this evidence:
# the old-form, new-form, and LINKED models it returns must each keep a usable,
# finite, positive-definite vcov and a passing second-order test, so downstream
# consumers can still form standard errors on the linked scale.
#
# This test asserts, for all three returned models:
#   * a non-empty vcov whose entries are finite and symmetric;
#   * strictly positive eigenvalues (positive definiteness => invertible
#     information matrix => usable standard errors);
#   * extract.mirt(fit, "secondordertest") == TRUE (retained, not dropped).
#
# References (APA 7th):
#   Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood estimation of
#     item parameters: Application of an EM algorithm. Psychometrika, 46(4),
#     443-459. https://doi.org/10.1007/BF02293801
#   Cai, L. (2010). High-dimensional exploratory item factor analysis by a
#     Metropolis-Hastings Robbins-Monro algorithm. Psychometrika, 75(1), 33-57.
#     https://doi.org/10.1007/s11336-009-9136-x
#   Chalmers, R. P. (2012). mirt: A multidimensional item response theory
#     package for the R environment. Journal of Statistical Software, 48(6),
#     1-29. https://doi.org/10.18637/jss.v048.i06
#   Kim, S. (2006). A comparative study of IRT fixed parameter calibration
#     methods. Journal of Educational Measurement, 43(4), 355-381.
#     https://doi.org/10.1111/j.1745-3984.2006.00021.x

test_that("SE=TRUE information matrix and second-order test survive linking", {
  skip_on_cran()
  skip_if_not_installed("mirt")

  set.seed(20260730)

  old_item_names <- paste0("old_", 1:6)
  new_item_names <- paste0("new_", 1:6)
  old_common_items <- old_item_names[1:4]
  new_common_items <- new_item_names[1:4]

  common_a <- c(1.02, 0.86, 1.29, 0.94)
  common_d <- c(-0.80, -0.20, 0.35, 0.70)
  old_a <- matrix(c(common_a, 1.11, 0.77), ncol = 1)
  old_d <- c(common_d, -0.45, 0.55)
  new_a <- matrix(c(common_a, 0.83, 1.24), ncol = 1)
  new_d <- c(common_d, 0.25, -0.60)

  old_data <- as.data.frame(mirt::simdata(
    a = old_a, d = old_d,
    itemtype = rep("2PL", length(old_item_names)), N = 1500
  ))
  new_data <- as.data.frame(mirt::simdata(
    a = new_a, d = new_d,
    itemtype = rep("2PL", length(new_item_names)), N = 1500
  ))
  names(old_data) <- old_item_names
  names(new_data) <- new_item_names

  old_model <- mirt::mirt(
    old_data, 1, itemtype = "2PL", method = "EM", SE = TRUE,
    verbose = FALSE, technical = list(NCYCLES = 500)
  )
  new_model <- mirt::mirt(
    new_data, 1, itemtype = "2PL", method = "EM", SE = TRUE,
    verbose = FALSE, technical = list(NCYCLES = 500)
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

  # Shared assertion helper: a usable, positive-definite information/vcov plus a
  # retained, passing second-order optimality test.
  expect_usable_information <- function(fit, label) {
    # The @vcov slot holds the parameter covariance matrix (inverse of the
    # observed-information matrix) when SE = TRUE; a 1x1 NA placeholder when not.
    vc <- as.matrix(fit@vcov)
    expect_gt(nrow(vc), 0)
    expect_true(all(is.finite(vc)),
                info = paste(label, "vcov must be entirely finite"))
    expect_true(isSymmetric(unname(vc), tol = 1e-6),
                info = paste(label, "vcov must be symmetric"))

    eigenvalues <- eigen(vc, symmetric = TRUE, only.values = TRUE)$values
    # Positive definite <=> all eigenvalues > 0 <=> the observed-information
    # matrix at the optimum is invertible, so standard errors exist.
    expect_true(all(eigenvalues > 0),
                info = paste(label, "vcov must be positive definite"))

    soc <- mirt::extract.mirt(fit, "secondordertest")
    expect_true(isTRUE(soc),
                info = paste(label, "second-order test must be retained/TRUE"))
  }

  expect_usable_information(linked$oldFormModel, "old form")
  expect_usable_information(linked$newFormModel, "new form")
  expect_usable_information(linked$LinkedModel, "linked form")
})
