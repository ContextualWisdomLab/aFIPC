test_that("interactive binary choices reject unbounded integer strings", {
  body_lines <- deparse(body(aFIPC::autoFIPC), width.cutoff = 500L)

  expect_equal(
    sum(grepl('grepl("^[12]$", n)', body_lines, fixed = TRUE)),
    3L
  )
  expect_false(
    any(grepl('grepl("^[0-9]+$", n)', body_lines, fixed = TRUE))
  )
})
