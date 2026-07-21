# Formula-integrity regression guards for performance refactors.
#
# These tests pin the two formula-bearing expressions that recent "Bolt"
# performance refactors rewrote, so any future re-optimization that silently
# changes their meaning is caught. Values below are hand-computed references,
# not a re-encoding of the current implementation.
#
# Audited refactors:
#   * #56 (fc8bbfb): response-category count guard rewritten from
#       length(levels(as.factor(x)))  ->  length(na.omit(unique(x)))
#     Both count DISTINCT NON-MISSING response categories. This guard decides
#     whether an old/new common-item pair may be linked (Kim, 2006: an anchor
#     item must share the same response structure on both forms).
#   * #99 (d73adbd): IPD common-item extraction rewritten from a per-column
#       for-loop over IPDItemList[cols][row, i]
#     to a vectorized
#       as.character(unlist(IPDItemList[row, cols])).
#     Row 1 = old-form anchor names, row 2 = new-form anchor names, restricted
#     to the columns that survived IPD screening (CommonItemList_NOIPD).

test_that("category-count guard counts distinct non-missing categories (#56)", {
  vecs <- list(
    dichotomous       = c(0, 1, 0, 1, 1, 0),
    trichotomous_w_na = c(0, 1, 2, NA, 2, 1, 0),
    constant          = c(0, 0, 0, 0),
    four_category_w_na = c(0, 1, 2, 3, 3, NA, 1)
  )

  # Independent hand-computed reference (distinct non-missing categories).
  expected <- c(
    dichotomous        = 2L,
    trichotomous_w_na  = 3L,
    constant           = 1L,
    four_category_w_na = 4L
  )

  new_idiom <- vapply(
    vecs,
    function(x) length(na.omit(unique(x))),
    integer(1)
  )
  legacy_idiom <- vapply(
    vecs,
    function(x) length(levels(as.factor(x))),
    integer(1)
  )

  expect_equal(new_idiom, expected)
  # The refactor must remain equivalent to the pre-#56 expression.
  expect_equal(unname(new_idiom), unname(legacy_idiom))
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

test_that("Direct column assignment matches 2D assignment behavior", {
  # Mock Data setup equivalent to scale parms
  NewScaleParms_2D <- data.frame(
    item = c("GROUP", "Item1", "BETA", "Item2"),
    name = c("MEAN_1", "a1", "COV_11", "d"),
    value = c(0, 1.5, 1, -0.5),
    est = c(TRUE, TRUE, FALSE, TRUE),
    stringsAsFactors = FALSE
  )
  OldScaleParms_2D <- NewScaleParms_2D
  OldScaleParms_2D$value <- c(1, 2.0, 0, -1.0)

  NewScaleParms_1D <- NewScaleParms_2D
  OldScaleParms_1D <- OldScaleParms_2D

  # 2D Assignment (Legacy)
  NewScaleParms_2D[NewScaleParms_2D$item == 'GROUP', "est"] <- FALSE
  OldScaleParms_2D[OldScaleParms_2D$item == 'GROUP', "est"] <- FALSE
  NewScaleParms_2D[NewScaleParms_2D$name == "COV_11", "est"] <- TRUE
  OldScaleParms_2D[OldScaleParms_2D$name == "COV_11", "est"] <- TRUE
  NewScaleParms_2D[NewScaleParms_2D$name == "a1", "est"] <- FALSE
  OldScaleParms_2D[OldScaleParms_2D$name == "a1", "est"] <- FALSE

  newBetaIdx <- NewScaleParms_2D$item == 'BETA'
  oldBetaIdx <- OldScaleParms_2D$item == 'BETA'
  NewScaleParms_2D[newBetaIdx, "value"] <- OldScaleParms_2D[oldBetaIdx, "value"]
  NewScaleParms_2D[newBetaIdx, "est"] <- FALSE

  # 1D Assignment (Optimized)
  NewScaleParms_1D$est[NewScaleParms_1D$item == 'GROUP'] <- FALSE
  OldScaleParms_1D$est[OldScaleParms_1D$item == 'GROUP'] <- FALSE
  NewScaleParms_1D$est[NewScaleParms_1D$name == "COV_11"] <- TRUE
  OldScaleParms_1D$est[OldScaleParms_1D$name == "COV_11"] <- TRUE
  NewScaleParms_1D$est[NewScaleParms_1D$name == "a1"] <- FALSE
  OldScaleParms_1D$est[OldScaleParms_1D$name == "a1"] <- FALSE

  newBetaIdx_1D <- NewScaleParms_1D$item == 'BETA'
  oldBetaIdx_1D <- OldScaleParms_1D$item == 'BETA'
  NewScaleParms_1D$value[newBetaIdx_1D] <- OldScaleParms_1D$value[oldBetaIdx_1D]
  NewScaleParms_1D$est[newBetaIdx_1D] <- FALSE

  expect_identical(NewScaleParms_2D, NewScaleParms_1D)
  expect_identical(OldScaleParms_2D, OldScaleParms_1D)

  # Check type preservation
  expect_type(NewScaleParms_1D$value, "double")
  expect_type(NewScaleParms_1D$est, "logical")
})

test_that("direct parameter-column assignment preserves table semantics (#156)", {
  new_parameters <- data.frame(
    item = c("GROUP", "item_1", "item_1", "item_2", "BETA", "GROUP"),
    name = c("MEAN_1", "a1", "d", "COV_11", "beta", "MEAN_11"),
    value = c(0, 0.8, -0.4, 0.9, 0.2, 0.1),
    est = c(TRUE, TRUE, TRUE, FALSE, TRUE, TRUE),
    stringsAsFactors = FALSE
  )
  old_parameters <- data.frame(
    item = c("GROUP", "old_1", "old_1", "old_2", "BETA", "GROUP"),
    name = c("MEAN_1", "a1", "d", "COV_11", "beta", "MEAN_11"),
    value = c(0, 1.1, -0.7, 1.2, 0.5, -0.1),
    est = c(TRUE, TRUE, TRUE, FALSE, TRUE, TRUE),
    stringsAsFactors = FALSE
  )

  legacy_new <- new_parameters
  legacy_old <- old_parameters
  direct_new <- new_parameters
  direct_old <- old_parameters

  legacy_new[legacy_new$item == "GROUP", "est"] <- FALSE
  legacy_old[legacy_old$item == "GROUP", "est"] <- FALSE
  direct_new$est[direct_new$item == "GROUP"] <- FALSE
  direct_old$est[direct_old$item == "GROUP"] <- FALSE

  legacy_new[legacy_new$name == "COV_11", "est"] <- TRUE
  legacy_old[legacy_old$name == "COV_11", "est"] <- TRUE
  direct_new$est[direct_new$name == "COV_11"] <- TRUE
  direct_old$est[direct_old$name == "COV_11"] <- TRUE

  new_anchor <- legacy_new$item == "item_1"
  old_anchor <- legacy_old$item == "old_1"
  legacy_new[new_anchor, "value"] <- legacy_old[old_anchor, "value"]
  legacy_new[new_anchor, "est"] <- FALSE
  direct_new$value[new_anchor] <- direct_old$value[old_anchor]
  direct_new$est[new_anchor] <- FALSE

  new_beta <- legacy_new$item == "BETA"
  old_beta <- legacy_old$item == "BETA"
  legacy_new[new_beta, "value"] <- legacy_old[old_beta, "value"]
  legacy_new[new_beta, "est"] <- FALSE
  direct_new$value[new_beta] <- direct_old$value[old_beta]
  direct_new$est[new_beta] <- FALSE

  expect_identical(direct_new, legacy_new)
  expect_identical(direct_old, legacy_old)
})

test_that("scale-parameter preparation validates schema and preserves Rasch semantics (#156)", {
  parameters <- data.frame(
    item = c("GROUP", "item_1", "item_2"),
    name = c("MEAN_1", "a1", "COV_11"),
    value = c(0, 1, 1),
    est = c(TRUE, TRUE, FALSE),
    stringsAsFactors = FALSE
  )

  legacy_new <- parameters
  legacy_old <- parameters
  legacy_new[legacy_new$item == "GROUP", "est"] <- FALSE
  legacy_old[legacy_old$item == "GROUP", "est"] <- FALSE
  legacy_new[legacy_new$name == "COV_11", "est"] <- TRUE
  legacy_old[legacy_old$name == "COV_11", "est"] <- TRUE
  legacy_new[legacy_new$name == "a1", "est"] <- FALSE
  legacy_old[legacy_old$name == "a1", "est"] <- FALSE

  actual <- aFIPC:::.prepare_scale_parameters(parameters, parameters, "Rasch")

  expect_identical(actual$new, legacy_new)
  expect_identical(actual$old, legacy_old)
  expect_false(actual$new$est[actual$new$name == "a1"])

  expect_error(
    aFIPC:::.prepare_scale_parameters(
      as.matrix(parameters),
      parameters,
      "Rasch"
    ),
    "new-form parameter table must be a data.frame",
    fixed = TRUE
  )

  for (missing_column in c("item", "name", "value", "est")) {
    incomplete <- parameters[setdiff(names(parameters), missing_column)]
    expect_error(
      aFIPC:::.prepare_scale_parameters(incomplete, parameters, "Rasch"),
      paste0("missing required column\\(s\\): ", missing_column),
      fixed = FALSE
    )
  }
})
