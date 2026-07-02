test_that("factor columns are handled correctly during IPD vectorization", {
  skip_if_not_installed("mirt")

  # Create a scenario where IPD runs and dataframe has factor or character types
  set.seed(42)
  old_item_names <- paste0("Item", 1:4)
  new_item_names <- paste0("Item", 1:4)

  dat_old <- mirt::simdata(a = matrix(runif(4, 0.8, 2)), d = matrix(rnorm(4)), N = 100, itemtype = "2PL")
  dat_new <- mirt::simdata(a = matrix(runif(4, 0.8, 2)), d = matrix(rnorm(4)), N = 100, itemtype = "2PL")
  colnames(dat_old) <- old_item_names
  colnames(dat_new) <- new_item_names

  old_mod <- mirt::mirt(dat_old, 1, itemtype = "2PL", SE = FALSE, verbose = FALSE)
  new_mod <- mirt::mirt(dat_new, 1, itemtype = "2PL", SE = FALSE, verbose = FALSE)

  # Run autoFIPC with checkIPD = TRUE to trigger the IPD logic
  res <- aFIPC::autoFIPC(
    newformXData = new_mod,
    oldformYData = old_mod,
    newformCommonItemNames = paste0("Item", 1:4),
    oldformCommonItemNames = paste0("Item", 1:4),
    itemtype = "2PL",
    checkIPD = TRUE,
    confirmCommonItems = TRUE
  )

  # If it didn't crash and returns the list with LinkedModel, factor logic is safe
  expect_type(res, "list")
  expect_true(!is.null(res$LinkedModel))
})
