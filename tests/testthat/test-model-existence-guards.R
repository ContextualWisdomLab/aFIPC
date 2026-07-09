test_that("autoFIPC model existence guards only inspect local state", {
  body_text <- paste(
    deparse(body(aFIPC::autoFIPC), width.cutoff = 500L),
    collapse = "\n"
  )

  unsafe_exists <- regmatches(
    body_text,
    gregexpr(
      "exists\\((['\"])(oldFormModel|newFormModel|modIPD_DIF|CommonItemList_NOIPD)\\1\\)",
      body_text,
      perl = TRUE
    )
  )[[1]]

  expect_equal(unsafe_exists, character())
})
