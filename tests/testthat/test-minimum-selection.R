test_that("minimum selection preserves the original named-sort result", {
  values <- c(item_a = 0.42, item_b = 0.03, item_c = 0.18)

  expect_identical(
    aFIPC:::.name_of_minimum(values),
    names(sort(values, decreasing = FALSE))[1L]
  )
})

test_that("minimum selection is deterministic for ties and empty inputs", {
  expect_identical(
    aFIPC:::.name_of_minimum(c(first = 0.1, second = 0.1)),
    "first"
  )
  expect_true(is.na(aFIPC:::.name_of_minimum(numeric())))
  expect_true(is.na(aFIPC:::.name_of_minimum(c(0.2, 0.1))))
})
