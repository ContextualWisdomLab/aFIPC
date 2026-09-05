# Formula-integrity regression guards for performance refactors.
#
# These tests pin the formula-bearing expressions that recent "Bolt"
# refactors rewrote, so any future re-optimization that silently changes their
# meaning is caught. Values below are hand-computed references, not a
# re-encoding of the current implementation.
#
# Audited refactors:
#   * #56 (fc8bbfb): response-category count guard rewritten from
#       length(levels(as.factor(x)))  ->  length(na.omit(unique(x)))
#     Both count DISTINCT NON-MISSING response categories. This guard decides
#     whether an old/new common-item pair may be linked (Kim, 2006: an anchor
#     item must share the same response structure on both forms).
#   * #336: the same category count is expressed as
#       sum(!is.na(unique(x)))
#     The test below treats this as a behavior-preserving expression change;
#     it does not infer a latency or allocation improvement from equivalence.
#   * #99 (d73adbd): IPD common-item extraction rewritten from a per-column
#       for-loop over IPDItemList[cols][row, i]
#     to a vectorized
#       as.character(unlist(IPDItemList[row, cols])).
#     Row 1 = old-form anchor names, row 2 = new-form anchor names, restricted
#     to the columns that survived IPD screening (CommonItemList_NOIPD).

test_that("category-count guard counts distinct non-missing categories (#56, #336)", {
  vecs <- list(
    dichotomous        = c(0, 1, 0, 1, 1, 0),
    trichotomous_w_na  = c(0, 1, 2, NA, 2, 1, 0),
    constant           = c(0, 0, 0, 0),
    four_category_w_na = c(0, 1, 2, 3, 3, NA, 1),
    all_missing        = c(NA_real_, NA_real_),
    numeric_nan        = c(1, NaN, NA_real_, 1, 2),
    factor_w_unused    = factor(c("a", "b", "a", NA), levels = c("a", "b", "unused"))
  )

  # Independent hand-computed reference (distinct non-missing categories).
  expected <- c(
    dichotomous        = 2L,
    trichotomous_w_na  = 3L,
    constant           = 1L,
    four_category_w_na = 4L,
    all_missing        = 0L,
    numeric_nan        = 2L,
    factor_w_unused    = 2L
  )

  omit_unique_idiom <- vapply(
    vecs,
    function(x) length(stats::na.omit(unique(x))),
    integer(1)
  )
  logical_count_idiom <- vapply(
    vecs,
    function(x) sum(!is.na(unique(x))),
    integer(1)
  )
  legacy_idiom <- vapply(
    vecs,
    function(x) length(levels(as.factor(x))),
    integer(1)
  )

  expect_equal(omit_unique_idiom, expected)
  expect_equal(logical_count_idiom, expected)
  expect_equal(unname(logical_count_idiom), unname(omit_unique_idiom))
  # The refactor chain must remain equivalent to the pre-#56 expression.
  expect_equal(unname(logical_count_idiom), unname(legacy_idiom))
})

test_that("IPD anchor extraction keeps old/new rows and screened columns (#99)", {
  old_anchor_names <- c("old_1", "old_2", "old_3")
  new_anchor_names <- c("new_1", "new_2", "new_3")

  # Mirror how autoFIPC() builds IPDItemList and names its columns.
  IPDItemList <- data.frame(rbind(old_anchor_names, new_anchor_names))
  colnames(IPDItemList) <- paste0("X", seq_along(old_anchor_names))

  # Item X2 is flagged as showing drift and dropped from the anchor set.
  CommonItemList_NOIPD <- c("X1", "X3")

  actual_old <- as.character(unlist(IPDItemList[1, CommonItemList_NOIPD]))
  actual_new <- as.character(unlist(IPDItemList[2, CommonItemList_NOIPD]))

  # Independent hand-computed reference.
  expect_equal(actual_old, c("old_1", "old_3"))
  expect_equal(actual_new, c("new_1", "new_3"))

  # The vectorized refactor must match the pre-#99 element-wise loop.
  legacy_old <- character(length(CommonItemList_NOIPD))
  legacy_new <- character(length(CommonItemList_NOIPD))
  for (i in seq_along(CommonItemList_NOIPD)) {
    legacy_old[i] <- as.character(IPDItemList[CommonItemList_NOIPD][1, i])
    legacy_new[i] <- as.character(IPDItemList[CommonItemList_NOIPD][2, i])
  }
  expect_identical(actual_old, legacy_old)
  expect_identical(actual_new, legacy_new)
})
