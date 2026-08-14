test_that("readline() input validation uses strict ^[12]$ matching", {
  lines <- readLines("../../R/aFIPC.R")

  # ^[12]$ 매칭이 3군데 있는지 확인
  strict_matches <- grep("grepl\\(\"\\^\\[12\\]\\$\"", lines)
  expect_equal(length(strict_matches), 3)

  # 기존 ^[0-9]+$ 매칭이 없는지 확인
  weak_matches <- grep("grepl\\(\"\\^\\[0-9\\]\\+\\$\"", lines)
  expect_equal(length(weak_matches), 0)
})
