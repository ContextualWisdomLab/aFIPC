test_that("autoFIPC fails safely when oldFormModel estimation input is invalid", {
  skip_if_not_installed("mirt")

  oldFormModel <- "non-local sentinel"
  old_data <- data.frame(item1 = rep(0, 100))
  new_data <- data.frame(item1 = rep(0, 100))

  expect_error(
    aFIPC::autoFIPC(
      oldformYData = old_data,
      newformXData = new_data,
      itemtype = '2PL',
      oldformCommonItemNames = "item1",
      newformCommonItemNames = "item1",
      confirmCommonItems = TRUE
    ),
    "Estimation failed. Please check test quality."
  )
})

test_that("autoFIPC ignores non-local newFormModel when new estimation fails", {
  skip_if_not_installed("mirt")

  set.seed(20260702)
  newFormModel <- "non-local sentinel"
  old_data <- mirt::simdata(
    a = matrix(c(0.9, 1.1, 1.2), ncol = 1),
    d = c(-0.5, 0.1, 0.6),
    N = 120,
    itemtype = "2PL"
  )
  colnames(old_data) <- paste0("item", 1:3)
  old_model <- suppressWarnings(mirt::mirt(
    old_data,
    1,
    itemtype = "2PL",
    SE = FALSE,
    verbose = FALSE
  ))
  new_data <- data.frame(
    item1 = rep(0, 120),
    item2 = rep(0, 120),
    item3 = rep(0, 120)
  )

  expect_error(
    aFIPC::autoFIPC(
      oldformYData = old_model,
      newformXData = new_data,
      itemtype = '2PL',
      oldformCommonItemNames = "item1",
      newformCommonItemNames = "item1",
      confirmCommonItems = TRUE
    ),
    "Estimation failed. Please check test quality."
  )
})

test_that("MHRM retry helper fails after the retry limit", {
  attempts <- 0L

  expect_error(
    aFIPC:::.fit_mhrm_with_retries("oldFormModel", 3L, function() {
      attempts <<- attempts + 1L
      stop("forced failure")
    }),
    "Estimation failed for oldFormModel after 3 MHRM retries"
  )

  expect_equal(attempts, 3L)
})

test_that("MHRM retry helper returns a successful retry result", {
  attempts <- 0L

  result <- aFIPC:::.fit_mhrm_with_retries("newFormModel", 3L, function() {
    attempts <<- attempts + 1L
    if (attempts < 2L) {
      stop("forced failure")
    }
    "ok"
  })

  expect_equal(result, "ok")
  expect_equal(attempts, 2L)
})
