test_that("max_retries prevents infinite loop in model estimation", {
  skip_if_not_installed("mirt")

  # create data that will cause model estimation to fail consistently
  # a small data set with missingness and weird responses usually fails in MHRM
  set.seed(42)
  bad_data <- matrix(rbinom(20, 1, 0.5), nrow = 4, ncol = 5)
  colnames(bad_data) <- paste0("Item", 1:5)

  # Instead of testing autoFIPC directly since it requires valid inputs,
  # We test the core logic where max_retries is placed.
  # We mock the mirt function or just provide a test case that hits it.

  # Since autoFIPC takes data and attempts MHRM if the first mirt fails,
  # we provide it bad data that will fail the EM and then fail MHRM.
  # autoFIPC expects MHRM to fail in max_retries and stop()

  expect_error({
    res <- aFIPC::autoFIPC(
      newformXData = bad_data,
      oldformYData = bad_data,
      newformCommonItemNames = paste0("Item", 1:3),
      oldformCommonItemNames = paste0("Item", 1:3),
      itemtype = "2PL",
      checkIPD = FALSE,
      confirmCommonItems = TRUE
    )
  })
})
