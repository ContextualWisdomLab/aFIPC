test_that("autoFIPC fails safely when oldFormModel estimation input is invalid", {
  skip_if_not_installed("mirt")

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
