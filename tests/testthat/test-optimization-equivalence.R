# Formula-integrity regression guards for performance refactors.
#
# These tests pin formula-bearing expressions that performance refactors rewrite.
# Expected values are hand-computed references rather than copies of production
# implementation, and legacy expressions remain only as compatibility oracles.

test_that("category-count guard counts distinct non-missing categories", {
  vecs <- list(
    dichotomous = c(0, 1, 0, 1, 1, 0),
    trichotomous_w_na = c(0, 1, 2, NA, 2, 1, 0),
    numeric_w_nan = c(1, NaN, 2, NA, 2, 1),
    character_w_na = c("A", "B", NA, "A", "C"),
    factor_w_na = factor(c("A", "B", NA, "A", "C"), levels = c("A", "B", "C", "unused")),
    constant = c(0, 0, 0, 0)
  )

  expected <- c(
    dichotomous = 2L,
    trichotomous_w_na = 3L,
    numeric_w_nan = 2L,
    character_w_na = 3L,
    factor_w_na = 3L,
    constant = 1L
  )

  candidate <- vapply(
    vecs,
    function(x) as.integer(sum(!is.na(unique(x)))),
    integer(1)
  )
  legacy_unique_then_omit <- vapply(
    vecs,
    function(x) length(stats::na.omit(unique(x))),
    integer(1)
  )
  legacy_omit_then_unique <- vapply(
    vecs,
    function(x) length(unique(stats::na.omit(x))),
    integer(1)
  )

  expect_equal(candidate, expected)
  expect_identical(candidate, legacy_unique_then_omit)
  expect_identical(candidate, legacy_omit_then_unique)
})

test_that("IPD anchor extraction keeps old/new rows and screened columns (#99)", {
  old_anchor_names <- c("old_1", "old_2", "old_3")
  new_anchor_names <- c("new_1", "new_2", "new_3")

  IPDItemList <- data.frame(rbind(old_anchor_names, new_anchor_names))
  colnames(IPDItemList) <- paste0("X", seq_along(old_anchor_names))

  CommonItemList_NOIPD <- c("X1", "X3")

  actual_old <- as.character(unlist(IPDItemList[1, CommonItemList_NOIPD]))
  actual_new <- as.character(unlist(IPDItemList[2, CommonItemList_NOIPD]))

  expect_equal(actual_old, c("old_1", "old_3"))
  expect_equal(actual_new, c("new_1", "new_3"))

  legacy_old <- character(length(CommonItemList_NOIPD))
  legacy_new <- character(length(CommonItemList_NOIPD))
  for (i in seq_along(CommonItemList_NOIPD)) {
    legacy_old[i] <- as.character(IPDItemList[CommonItemList_NOIPD][1, i])
    legacy_new[i] <- as.character(IPDItemList[CommonItemList_NOIPD][2, i])
  }
  expect_identical(actual_old, legacy_old)
  expect_identical(actual_new, legacy_new)
})
