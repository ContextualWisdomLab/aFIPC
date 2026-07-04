test_that("autoFIPC non-interactive error checks", {
  skip_if_not_installed("mirt")
  set.seed(42)
  dat_old <- mirt::simdata(matrix(runif(5, 0.8, 2)), matrix(rnorm(5)), N = 50, itemtype = "2PL")
  dat_new <- mirt::simdata(matrix(runif(5, 0.8, 2)), matrix(rnorm(5)), N = 50, itemtype = "2PL")
  colnames(dat_old) <- paste0("I", 1:5)
  colnames(dat_new) <- paste0("I", 1:5)
  old_mod <- mirt::mirt(dat_old, 1, itemtype = "2PL", SE = FALSE, verbose = FALSE)
  new_mod <- mirt::mirt(dat_new, 1, itemtype = "2PL", SE = FALSE, verbose = FALSE)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_mod,
      oldformYData = old_mod,
      newformCommonItemNames = c("I1", "I2"),
      oldformCommonItemNames = c("I1"),
      confirmCommonItems = TRUE
    ),
    "Common Items are not equal"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_mod,
      oldformYData = old_mod,
      newformCommonItemNames = character(0),
      oldformCommonItemNames = character(0),
      confirmCommonItems = TRUE
    ),
    "Please provide common item names"
  )
})
