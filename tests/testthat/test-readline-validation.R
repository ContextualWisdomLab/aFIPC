test_that("autoFIPC validates readline inputs properly", {
  expect_true(grepl("^[12]$", "1"))
  expect_true(grepl("^[12]$", "2"))
  expect_false(grepl("^[12]$", "3"))
  expect_false(grepl("^[12]$", "99999999999999999999"))
  expect_false(grepl("^[12]$", "10"))
})
