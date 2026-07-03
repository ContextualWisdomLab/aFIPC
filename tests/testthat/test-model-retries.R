test_that("model estimation fails cleanly after max retries", {
  skip_if_not_installed("mirt")

  set.seed(20260630)
  old_item_names <- paste0("old_item_", 1:6)
  new_item_names <- paste0("new_item_", 1:6)
  old_common_items <- old_item_names[1:4]
  new_common_items <- new_item_names[1:4]

  # Forcing an error in mirt by passing non-sensical data shapes
  old_data <- data.frame(a = c("A", "B"), b = c("C", "D"))
  new_data <- data.frame(c = c("E", "F"), d = c("G", "H"))
  names(old_data) <- old_item_names[1:2]
  names(new_data) <- new_item_names[1:2]

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = new_common_items[1:2],
      oldformCommonItemNames = old_common_items[1:2],
      itemtype = "2PL",
      checkIPD = FALSE,
      tryEM = FALSE,
      freeMEAN = FALSE,
      forceNormalZeroOne = TRUE,
      confirmCommonItems = TRUE
    ),
    "Estimation failed repeatedly"
  )
})
