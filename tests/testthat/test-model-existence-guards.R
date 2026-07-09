test_that("autoFIPC model existence guards only inspect local state", {
  source <- readLines(test_path("../../R/aFIPC.R"), warn = FALSE)

  unsafe_exists <- grep("exists\\('(oldFormModel|newFormModel|modIPD_DIF|CommonItemList_NOIPD)'\\)", source, value = TRUE)

  expect_equal(unsafe_exists, character())
})
