# Formula-integrity regression guards for performance refactors.
#
# These tests pin formula-bearing expressions that performance refactors
# changed. Expected values are independent references rather than copies of the
# current implementation.

test_that("category-count guard counts distinct non-missing categories", {
  vecs <- list(
    dichotomous = c(0, 1, 0, 1, 1, 0),
    trichotomous_w_na = c(0, 1, 2, NA, 2, 1, 0),
    trichotomous_w_nan = c(0, 1, 2, NaN, 2, 1, 0),
    constant = c(0, 0, 0, 0),
    four_category_w_na = c(0, 1, 2, 3, 3, NA, 1)
  )

  expected <- c(
    dichotomous = 2,
    trichotomous_w_na = 3,
    trichotomous_w_nan = 3,
    constant = 1,
    four_category_w_na = 4
  )

  candidate <- vapply(
    vecs,
    function(x) sum(!is.na(unique(x))),
    numeric(1)
  )
  predecessor <- vapply(
    vecs,
    function(x) length(stats::na.omit(unique(x))),
    integer(1)
  )
  original <- vapply(
    vecs,
    function(x) length(levels(as.factor(x))),
    integer(1)
  )

  expect_equal(candidate, expected)
  expect_equal(unname(candidate), unname(predecessor))
  expect_equal(unname(candidate), unname(original))
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
