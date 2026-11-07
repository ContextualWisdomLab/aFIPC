library(testthat)

test_that("surveyFA preserves matrix column identity through autofix selection", {
  mirt_namespace <- asNamespace("mirt")
  original_mirt <- get("mirt", envir = mirt_namespace)
  original_itemfit <- get("itemfit", envir = mirt_namespace)
  on.exit({
    assignInNamespace("mirt", original_mirt, ns = "mirt")
    assignInNamespace("itemfit", original_itemfit, ns = "mirt")
  }, add = TRUE)

  assignInNamespace(
    "mirt",
    function(...) structure(list(), class = "surveyFA_rejected_fit"),
    ns = "mirt"
  )
  assignInNamespace(
    "itemfit",
    function(...) {
      data.frame(
        p = c(0.8, 0.01, 0.7),
        row.names = c("Item1", "Item2", "Item3")
      )
    },
    ns = "mirt"
  )

  responses <- matrix(
    c(
      0, 0, 1,
      0, 1, 1,
      1, 0, 0,
      1, 1, 0
    ),
    nrow = 4,
    byrow = TRUE,
    dimnames = list(NULL, c("Item1", "Item2", "Item3"))
  )

  expect_error(
    surveyFA(responses, SE = FALSE, maxItemRemovals = 1L),
    "Removed items: Item2",
    fixed = TRUE
  )
})
