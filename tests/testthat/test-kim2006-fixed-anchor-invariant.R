# Directive item 1 — Fixed-item-parameter linking invariant (Kim, 2006).
#
# Kim (2006) formalizes fixed parameter calibration (FPC): the old-form anchor
# (common) item parameters are treated as KNOWN and held fixed while the new
# form is calibrated, so the new form is placed directly on the established base
# scale rather than transformed after the fact. This suite pins that invariant
# end-to-end through autoFIPC(): after linking, every declared anchor must carry
# its old-form parameter value verbatim and must be flagged as NOT estimated,
# while every non-anchor new-form parameter must remain free to move onto the
# fixed base scale.
#
# This complements test-fixed-parameter-calibration.R with an independent,
# differently-parameterized scenario (distinct seed, item counts, and anchor
# set) so the invariant is guarded by more than a single fixture.
#
# References (APA 7th):
#   Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood estimation of
#     item parameters: Application of an EM algorithm. Psychometrika, 46(4),
#     443-459. https://doi.org/10.1007/BF02293801
#   Chalmers, R. P. (2012). mirt: A multidimensional item response theory
#     package for the R environment. Journal of Statistical Software, 48(6),
#     1-29. https://doi.org/10.18637/jss.v048.i06
#   Kim, S. (2006). A comparative study of IRT fixed parameter calibration
#     methods. Journal of Educational Measurement, 43(4), 355-381.
#     https://doi.org/10.1111/j.1745-3984.2006.00021.x

test_that("autoFIPC holds anchor parameters at their old-form values (Kim, 2006)", {
  skip_on_cran()
  skip_if_not_installed("mirt")

  set.seed(20260729)

  old_item_names <- paste0("old_", 1:8)
  new_item_names <- paste0("new_", 1:8)
  old_common_items <- old_item_names[1:5]
  new_common_items <- new_item_names[1:5]

  # Common items (1:5) share identical true parameters across forms so the base
  # scale is genuinely established; unique items (6:8) differ between forms.
  common_a <- c(0.91, 1.14, 1.32, 0.78, 1.05)
  common_d <- c(-0.95, -0.30, 0.20, 0.75, -0.55)
  old_a <- matrix(c(common_a, 0.88, 1.21, 0.69), ncol = 1)
  old_d <- c(common_d, 0.40, -0.70, 0.30)
  new_a <- matrix(c(common_a, 1.10, 0.83, 1.27), ncol = 1)
  new_d <- c(common_d, -0.20, 0.60, -0.45)

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

  old_values <- mirt::mod2values(old_model)
  linked_values <- mirt::mod2values(linked$LinkedModel)

  # Invariant, first half: each anchor keeps its OLD-form value and is fixed.
  for (i in seq_along(old_common_items)) {
    old_fixed <- old_values[
      old_values$item == old_common_items[i] &
        old_values$name %in% c("a1", "d"),
      c("name", "value")
    ]
    linked_fixed <- linked_values[
      linked_values$item == new_common_items[i] &
        linked_values$name %in% c("a1", "d"),
      c("name", "value", "est")
    ]
    expect_equal(linked_fixed$name, old_fixed$name)
    expect_equal(linked_fixed$value, old_fixed$value, tolerance = 1e-6)
    expect_false(any(linked_fixed$est))
  }

  # Invariant, second half: non-anchor new-form parameters stay free so they
  # are estimated onto the fixed base scale (Kim, 2006).
  new_unique_items <- setdiff(new_item_names, new_common_items)
  free_new <- linked_values[
    linked_values$item %in% new_unique_items &
      linked_values$name %in% c("a1", "d"),
    "est"
  ]
  expect_true(all(free_new))
})
