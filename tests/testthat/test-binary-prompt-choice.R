test_that("common-item confirmation retries out-of-domain numeric input", {
  testthat::local_mocked_bindings(
    interactive = function() TRUE,
    readline = function(...) "999999999999999999999999999999999999999999999999999999",
    .package = "base"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(item_1 = c(0, 1)),
      oldformYData = data.frame(item_1 = c(0, 1)),
      newformCommonItemNames = "item_1",
      oldformCommonItemNames = "item_1",
      itemtype = "2PL"
    ),
    "Too many invalid common item confirmation attempts",
    fixed = TRUE
  )
})

test_that("old-form BILOG prompt rejects values outside the documented choices", {
  testthat::local_mocked_bindings(
    interactive = function() TRUE,
    readline = function(...) "3",
    .package = "base"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(item_1 = c(0, 1)),
      oldformYData = data.frame(item_1 = c(0, 1)),
      newformCommonItemNames = "item_1",
      oldformCommonItemNames = "item_1",
      itemtype = "3PL",
      confirmCommonItems = TRUE
    ),
    "Too many invalid oldform BILOG prior attempts",
    fixed = TRUE
  )
})
