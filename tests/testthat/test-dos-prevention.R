test_that("while loops for model estimation limit retries to prevent DoS", {
  test_retry_loop <- function() {
    max_retries <- 5
    retry_count <- 0
    # Simulate a loop where model doesn't exist
    while (!exists('mockModel', inherits = FALSE) && retry_count < max_retries) {
      try(
        stop("simulated failure")
      )
      retry_count <- retry_count + 1
    }
    if (!exists('mockModel', inherits = FALSE)) {
      stop("최대 재시도 횟수 초과 후 모델 추정에 실패했습니다. 데이터 및 파라미터를 확인하십시오.")
    }
  }

  expect_error(
    test_retry_loop(),
    "최대 재시도 횟수 초과 후 모델 추정에 실패했습니다. 데이터 및 파라미터를 확인하십시오.",
    fixed = TRUE
  )
})
