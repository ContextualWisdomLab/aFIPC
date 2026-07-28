test_that("autoFIPC is exported", {
  expect_true("autoFIPC" %in% getNamespaceExports("aFIPC"))
  expect_true(is.function(aFIPC::autoFIPC))
})

test_that("autoFIPC executes without errors in non-interactive environment", {
  skip_if_not_installed("mirt")

  set.seed(123)
  dat_old <- mirt::simdata(
    a = matrix(runif(10, 0.8, 2)),
    d = matrix(rnorm(10)),
    N = 100,
    itemtype = "2PL"
  )
  dat_new <- mirt::simdata(
    a = matrix(runif(10, 0.8, 2)),
    d = matrix(rnorm(10)),
    N = 100,
    itemtype = "2PL"
  )

  colnames(dat_old) <- paste0("Item", 1:10)
  colnames(dat_new) <- c(paste0("Item", 1:5), paste0("NewItem", 6:10))

  old_mod <- mirt::mirt(dat_old, 1, itemtype = "2PL", SE = FALSE, verbose = FALSE)
  new_mod <- mirt::mirt(dat_new, 1, itemtype = "2PL", SE = FALSE, verbose = FALSE)

  res <- aFIPC::autoFIPC(
    newformXData = new_mod,
    oldformYData = old_mod,
    newformCommonItemNames = paste0("Item", 1:5),
    oldformCommonItemNames = paste0("Item", 1:5),
    itemtype = "2PL",
    checkIPD = FALSE,
    confirmCommonItems = TRUE
  )

  expect_type(res, "list")
  expect_true("ExpectedScoreOldform" %in% names(res))
  expect_true("ThetaOldform" %in% names(res))
})
