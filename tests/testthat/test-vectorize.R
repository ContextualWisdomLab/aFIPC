test_that("Vectorized name extraction works correctly", {
  IPDItemList <- data.frame(
    item1 = c("old_item1", "new_item1"),
    item2 = c("old_item2", "new_item2"),
    stringsAsFactors = FALSE
  )

  CommonItemList_NOIPD <- c("item1", "item2")

  old_names <- as.character(unlist(IPDItemList[CommonItemList_NOIPD][1, ]))
  new_names <- as.character(unlist(IPDItemList[CommonItemList_NOIPD][2, ]))

  expect_equal(old_names, c("old_item1", "old_item2"))
  expect_equal(new_names, c("new_item1", "new_item2"))
})
