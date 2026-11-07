# Directive item 4 — Zero-score / perfect-score robustness.
#
# Real calibration samples contain examinees who answer every item incorrectly
# (all-0) or every item correctly (all-1), and items whose responses are highly
# skewed toward one category. Maximum-likelihood ability estimates diverge to
# +/- infinity for perfect and zero scores, but the marginal / Bayesian
# machinery aFIPC relies on keeps them finite: MML estimation integrates over a
# proper population prior (Bock & Aitkin, 1981), and the MAP ability scores
# autoFIPC returns are shrunk toward that prior and therefore finite even at the
# boundaries (Mislevy & Wu, 1996). This test injects all-0 and all-1 response
# vectors plus deliberately extreme (near-degenerate) unique items and asserts
# that fixed-item calibration (Kim, 2006) neither crashes nor emits non-finite
# item parameters, ability estimates, or expected scores.
#
# Note on scope: a fully CONSTANT item (a single observed category) is not
# identifiable under any IRT estimator, so this fixture keeps every item
# non-constant by construction (the injected all-0 and all-1 rows guarantee at
# least one response in each category) while still exercising the skewed,
# boundary-heavy regime the directive targets.
#
# References (APA 7th):
#   Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood estimation of
#     item parameters: Application of an EM algorithm. Psychometrika, 46(4),
#     443-459. https://doi.org/10.1007/BF02293801
#   Kim, S. (2006). A comparative study of IRT fixed parameter calibration
#     methods. Journal of Educational Measurement, 43(4), 355-381.
#     https://doi.org/10.1111/j.1745-3984.2006.00021.x
#   Mislevy, R. J., & Wu, P.-K. (1996). Missing responses and IRT ability
#     estimation: Omits, choice, time limits, and adaptive testing (ETS
#     Research Report No. RR-96-30-ONR). Educational Testing Service.
#     https://doi.org/10.1002/j.2333-8504.1996.tb01708.x

test_that("autoFIPC survives zero-score, perfect-score, and skewed items", {
  skip_on_cran()
  skip_if_not_installed("mirt")

  set.seed(20260801)

  old_item_names <- paste0("old_", 1:6)
  new_item_names <- paste0("new_", 1:6)
  old_common_items <- old_item_names[1:4]
  new_common_items <- new_item_names[1:4]

  common_a <- c(1.00, 0.90, 1.20, 0.85)
  common_d <- c(-0.60, -0.10, 0.30, 0.65)
  # Unique items 5:6 are deliberately extreme in difficulty to create heavily
  # skewed, near-degenerate response columns.
  old_a <- matrix(c(common_a, 1.15, 0.80), ncol = 1)
  old_d <- c(common_d, 3.2, -3.0)
  new_a <- matrix(c(common_a, 0.95, 1.10), ncol = 1)
  new_d <- c(common_d, -3.1, 3.3)

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

  # Inject boundary examinees: rows 1:3 all-incorrect, rows 4:6 all-correct.
  # This also guarantees every item has >=3 zeros and >=3 ones (non-constant).
  old_data[1:3, ] <- 0
  old_data[4:6, ] <- 1
  new_data[1:3, ] <- 0
  new_data[4:6, ] <- 1

  # Sanity guard: no item collapsed to a single category.
  expect_true(all(vapply(old_data, function(x) length(unique(x)) >= 2, logical(1))))
  expect_true(all(vapply(new_data, function(x) length(unique(x)) >= 2, logical(1))))

  old_model <- mirt::mirt(
    old_data, 1, itemtype = "2PL", method = "EM", SE = TRUE,
    verbose = FALSE, technical = list(NCYCLES = 800)
  )
  new_model <- mirt::mirt(
    new_data, 1, itemtype = "2PL", method = "EM", SE = TRUE,
    verbose = FALSE, technical = list(NCYCLES = 800)
  )

  # A thrown error here fails the test: calibration must complete despite the
  # boundary (all-0 / all-1) examinees and skewed items.
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

  expect_type(linked, "list")

  # Linked item parameters must all be finite despite the boundary examinees.
  linked_values <- mirt::mod2values(linked$LinkedModel)
  item_params <- linked_values[
    linked_values$name %in% c("a1", "d"), "value"
  ]
  expect_true(all(is.finite(item_params)))

  # MAP ability estimates on all three forms remain finite at the boundaries.
  expect_true(all(is.finite(linked$ThetaOldform)))
  expect_true(all(is.finite(linked$ThetaNewform)))
  expect_true(all(is.finite(linked$ThetaLinkedform)))

  # Expected test scores remain finite as well.
  expect_true(all(is.finite(linked$ExpectedScoreOldform)))
  expect_true(all(is.finite(linked$ExpectedScoreNewform)))
  expect_true(all(is.finite(linked$ExpectedScoreLinkedform)))
})
