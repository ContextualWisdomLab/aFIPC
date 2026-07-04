test_that("which optimization correctly matches items", {
  skip_if_not_installed("mirt")

  # A small dummy test to just run autoFIPC and verify it doesn't crash
  # with the new variables `new_idx` and `old_idx` we introduced.
  set.seed(42)
  dat_old <- mirt::simdata(matrix(runif(5, 0.8, 2)), matrix(rnorm(5)), N = 50, itemtype = "2PL")
  dat_new <- mirt::simdata(matrix(runif(5, 0.8, 2)), matrix(rnorm(5)), N = 50, itemtype = "2PL")

  colnames(dat_old) <- paste0("I", 1:5)
  colnames(dat_new) <- paste0("I", 1:5)

  old_mod <- mirt::mirt(dat_old, 1, itemtype = "2PL", SE = FALSE, verbose = FALSE)
  new_mod <- mirt::mirt(dat_new, 1, itemtype = "2PL", SE = FALSE, verbose = FALSE)

  res <- aFIPC::autoFIPC(
    newformXData = new_mod,
    oldformYData = old_mod,
    newformCommonItemNames = c("I1", "I2"),
    oldformCommonItemNames = c("I1", "I2"),
    itemtype = "2PL",
    checkIPD = FALSE,
    confirmCommonItems = TRUE
  )

  expect_type(res, "list")
})
