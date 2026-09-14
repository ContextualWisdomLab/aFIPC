test_that("autoFIPC fails fast when common-item mappings do not resolve", {
  new_data <- data.frame(
    new_anchor = c(0, 1, 0, 1),
    new_unique = c(1, 0, 1, 0),
    check.names = FALSE
  )
  old_data <- data.frame(
    old_anchor = c(0, 1, 1, 0),
    old_unique = c(1, 0, 0, 1),
    check.names = FALSE
  )

  expect_error(
    autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = "missing_new_anchor",
      oldformCommonItemNames = "old_anchor",
      itemtype = "2PL",
      confirmCommonItems = FALSE
    ),
    "newformCommonItemNames.*not present"
  )

  expect_error(
    autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = "new_anchor",
      oldformCommonItemNames = "missing_old_anchor",
      itemtype = "2PL",
      confirmCommonItems = FALSE
    ),
    "oldformCommonItemNames.*not present"
  )
})

test_that("autoFIPC rejects ambiguous common-item mappings before confirmation", {
  new_data <- data.frame(
    new_anchor = c(0, 1, 0, 1),
    new_unique = c(1, 0, 1, 0),
    check.names = FALSE
  )
  old_data <- data.frame(
    old_anchor = c(0, 1, 1, 0),
    old_unique = c(1, 0, 0, 1),
    check.names = FALSE
  )

  expect_error(
    autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = c("new_anchor", "new_anchor"),
      oldformCommonItemNames = c("old_anchor", "old_unique"),
      itemtype = "2PL",
      confirmCommonItems = FALSE
    ),
    "newformCommonItemNames.*unique"
  )

  expect_error(
    autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = c("new_anchor", "new_unique"),
      oldformCommonItemNames = c("old_anchor", "old_anchor"),
      itemtype = "2PL",
      confirmCommonItems = FALSE
    ),
    "oldformCommonItemNames.*unique"
  )

  expect_error(
    autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = NA_character_,
      oldformCommonItemNames = "old_anchor",
      itemtype = "2PL",
      confirmCommonItems = FALSE
    ),
    "newformCommonItemNames.*non-missing"
  )

  expect_error(
    autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = "",
      oldformCommonItemNames = "old_anchor",
      itemtype = "2PL",
      confirmCommonItems = FALSE
    ),
    "newformCommonItemNames.*non-empty"
  )
})

test_that("factor common-item names preserve the documented accepted type", {
  new_data <- data.frame(
    new_anchor = c(0, 1, 0, 1),
    new_unique = c(1, 0, 1, 0),
    check.names = FALSE
  )
  old_data <- data.frame(
    old_anchor = c(0, 1, 1, 0),
    old_unique = c(1, 0, 0, 1),
    check.names = FALSE
  )

  expect_error(
    autoFIPC(
      newformXData = new_data,
      oldformYData = old_data,
      newformCommonItemNames = factor("new_anchor"),
      oldformCommonItemNames = factor("old_anchor"),
      itemtype = "2PL",
      confirmCommonItems = FALSE
    ),
    "Please write down pairs correctly"
  )
})
