test_that("autoFIPC handles basic input correctly", {
  skip_if_not_installed("mirt")
  library(mirt)

  # Need enough items to estimate the model properly to avoid "too few degrees of freedom"
  a <- matrix(rep(1, 6))
  d_old <- matrix(rep(0, 6))
  d_new <- matrix(rep(0.5, 6))
  d_new[6] <- 0 # common item

  set.seed(123)
  theta_old <- matrix(rnorm(200))
  theta_new <- matrix(rnorm(200, mean = 0.5))

  data_old <- simdata(a, d_old, 200, itemtype = '2PL', Theta = theta_old)
  data_new <- simdata(a, d_new, 200, itemtype = '2PL', Theta = theta_new)

  colnames(data_old) <- c("Item1", "Item2", "Item3", "Item4", "Item5", "CommonItem")
  colnames(data_new) <- c("Item6", "Item7", "Item8", "Item9", "Item10", "CommonItem")

  mod_old <- mirt(data_old, 1, itemtype = '2PL', SE = FALSE, verbose = FALSE)
  mod_new <- mirt(data_new, 1, itemtype = '2PL', SE = FALSE, verbose = FALSE)

  res <- suppressMessages(
    aFIPC::autoFIPC(
      oldformYData = mod_old,
      newformXData = mod_new,
      newformCommonItemNames = c("CommonItem"),
      oldformCommonItemNames = c("CommonItem"),
      itemtype = '2PL',
      checkIPD = FALSE,
      fix.expected.score = FALSE,
      empiricalhist = FALSE,
      forceNormalZeroOne = FALSE,
      confirmCommonItems = TRUE
    )
  )

  expect_type(res, "list")
  expect_true(!is.null(res$LinkedModel))
  expect_true(!is.null(res$ExpectedScoreLinkedform))

  linked_pars <- extract.mirt(res$LinkedModel, 'pars')
  old_pars <- extract.mirt(mod_old, 'pars')

  expect_equal(linked_pars[[6]]@par, old_pars[[6]]@par, tolerance = 1e-6)
})

test_that("autoFIPC handles forceNormalZeroOne and empiricalhist", {
  skip_if_not_installed("mirt")
  library(mirt)

  a <- matrix(rep(1, 6))
  d <- matrix(rep(0, 6))

  set.seed(456)
  data_old <- simdata(a, d, 200, itemtype = '2PL')
  data_new <- simdata(a, d, 200, itemtype = '2PL')

  colnames(data_old) <- c("I1", "I2", "I3", "I4", "I5", "C1")
  colnames(data_new) <- c("I6", "I7", "I8", "I9", "I10", "C1")

  mod_old <- mirt(data_old, 1, itemtype = '2PL', SE = FALSE, verbose = FALSE)
  mod_new <- mirt(data_new, 1, itemtype = '2PL', SE = FALSE, verbose = FALSE)

  res <- suppressMessages(
    aFIPC::autoFIPC(
      oldformYData = mod_old,
      newformXData = mod_new,
      newformCommonItemNames = c("C1"),
      oldformCommonItemNames = c("C1"),
      itemtype = '2PL',
      checkIPD = FALSE,
      fix.expected.score = FALSE,
      empiricalhist = TRUE,
      forceNormalZeroOne = TRUE,
      confirmCommonItems = TRUE
    )
  )

  expect_type(res, "list")
  expect_true(!is.null(res$LinkedModel))
})

test_that("autoFIPC raises error in non-interactive session for inputs", {
  # interactive() should be FALSE by default in testthat environments
  expect_error(
    aFIPC::autoFIPC(
      newformXData = 1,
      oldformYData = 2,
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Common item confirmation requires an interactive session"
  )
})

test_that("autoFIPC does not implicitly approve supplied common items", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = 1,
      oldformYData = 2,
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = FALSE
    ),
    "Please write down pairs correctly"
  )
})
