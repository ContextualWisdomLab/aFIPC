# Directive item 3 — Concurrent calibration missing-value robustness.
#
# In common-item nonequivalent-groups (NEAT) and planned-missing booklet
# designs, examinees respond to only a subset of the items; the unadministered
# cells are structurally missing (NA). Under the standard ignorable / MAR
# assumption for such designs, marginal maximum likelihood integrates the
# person likelihood over only the OBSERVED responses, so missing-by-design
# cells neither bias nor break estimation (Bock & Aitkin, 1981; Mislevy & Wu,
# 1996). This test builds two non-overlapping booklets per form — every
# examinee sees all anchor items but only one form-specific block of unique
# items — and asserts that autoFIPC calibrates end-to-end without error while
# the Kim (2006) fixed-anchor invariant still holds.
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

test_that("autoFIPC calibrates planned-missing booklets and keeps anchors fixed", {
  skip_on_cran()
  skip_if_not_installed("mirt")

  set.seed(20260731)

  old_item_names <- paste0("old_", 1:7)
  new_item_names <- paste0("new_", 1:7)
  # Items 1:4 are the fully-observed anchors; 5:7 are the form-specific block
  # split across two booklets.
  old_common_items <- old_item_names[1:4]
  new_common_items <- new_item_names[1:4]

  common_a <- c(0.95, 1.18, 0.82, 1.27)
  common_d <- c(-0.70, -0.15, 0.40, 0.85)
  old_a <- matrix(c(common_a, 1.05, 0.88, 1.16), ncol = 1)
  old_d <- c(common_d, -0.35, 0.30, 0.60)
  new_a <- matrix(c(common_a, 0.90, 1.22, 0.79), ncol = 1)
  new_d <- c(common_d, 0.20, -0.50, 0.45)

  n_persons <- 1600
  old_data <- as.data.frame(mirt::simdata(
    a = old_a, d = old_d,
    itemtype = rep("2PL", length(old_item_names)), N = n_persons
  ))
  new_data <- as.data.frame(mirt::simdata(
    a = new_a, d = new_d,
    itemtype = rep("2PL", length(new_item_names)), N = n_persons
  ))
  names(old_data) <- old_item_names
  names(new_data) <- new_item_names

  # Planned-missing booklet spiral: anchors seen by everyone; the two unique
  # blocks are administered to disjoint halves, the rest are NA (missing by
  # design, not by response behavior).
  booklet <- rep(c(1L, 2L), length.out = n_persons)
  old_block_a <- old_item_names[5:6]
  old_block_b <- old_item_names[7]
  new_block_a <- new_item_names[5:6]
  new_block_b <- new_item_names[7]
  old_data[booklet == 1L, old_block_b] <- NA
  old_data[booklet == 2L, old_block_a] <- NA
  new_data[booklet == 1L, new_block_b] <- NA
  new_data[booklet == 2L, new_block_a] <- NA

  # Structural missingness must be present but the anchors must stay complete.
  expect_true(anyNA(old_data))
  expect_true(anyNA(new_data))
  expect_false(anyNA(old_data[, old_common_items]))
  expect_false(anyNA(new_data[, new_common_items]))

  old_model <- mirt::mirt(
    old_data, 1, itemtype = "2PL", method = "EM", SE = TRUE,
    verbose = FALSE, technical = list(NCYCLES = 800)
  )
  new_model <- mirt::mirt(
    new_data, 1, itemtype = "2PL", method = "EM", SE = TRUE,
    verbose = FALSE, technical = list(NCYCLES = 800)
  )

  # A thrown error here fails the test: the calibration must complete despite
  # the structurally missing (planned-missing) cells.
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
  expect_true(all(c("LinkedModel", "ThetaLinkedform") %in% names(linked)))

  # Anchors remain fixed to their old-form values despite the missing blocks.
  old_values <- mirt::mod2values(old_model)
  linked_values <- mirt::mod2values(linked$LinkedModel)
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
    expect_equal(linked_fixed$value, old_fixed$value, tolerance = 1e-6)
    expect_false(any(linked_fixed$est))
  }

  # Every calibrated person receives a finite ability estimate on the linked
  # scale even though each answered only a booklet-sized subset.
  expect_true(all(is.finite(linked$ThetaLinkedform)))
})
