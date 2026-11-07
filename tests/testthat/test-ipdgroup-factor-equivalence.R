test_that("explicit IPD group levels preserve the protected factor contract", {
  cardinalities <- list(
    c(old_form = 1L, new_form = 1L),
    c(old_form = 3L, new_form = 5L),
    c(old_form = 37L, new_form = 61L)
  )

  for (sizes in cardinalities) {
    labels <- c(
      rep("oldForm", sizes[["old_form"]]),
      rep("newForm", sizes[["new_form"]])
    )
    protected <- as.factor(labels)
    candidate <- factor(labels, levels = c("newForm", "oldForm"))

    expect_identical(candidate, protected)
    expect_identical(levels(candidate), c("newForm", "oldForm"))
  }
})
