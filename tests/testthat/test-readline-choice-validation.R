test_that("interactive yes/no prompts accept only their declared choices", {
  source_text <- paste(deparse(body(aFIPC::autoFIPC)), collapse = "\n")

  bounded_choice_pattern <- 'grepl("^[12]$", n)'
  legacy_unbounded_pattern <- 'grepl("^[0-9]+$", n)'

  expect_equal(
    lengths(regmatches(source_text, gregexpr(bounded_choice_pattern, source_text, fixed = TRUE))),
    3L
  )
  expect_false(grepl(legacy_unbounded_pattern, source_text, fixed = TRUE))
})
