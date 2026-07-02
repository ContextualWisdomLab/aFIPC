library(aFIPC)
test_that("while loops for model estimation limit retries to prevent DoS", {
  # Mock mirt completely to simulate failure
  mock_mirt <- function(...) { stop("simulated failure") }

  with_mocked_bindings(
    {
      expect_error(
        autoFIPC(
          oldformYData = matrix(sample(c(0, 1), 100, replace = TRUE), ncol=5, dimnames=list(NULL, paste0("Item", 1:5))),
          newformXData = matrix(sample(c(0, 1), 100, replace = TRUE), ncol=5, dimnames=list(NULL, paste0("Item", 1:5))),
          oldformCommonItemNames = paste0("Item", 1:3),
          newformCommonItemNames = paste0("Item", 1:3),
          confirmCommonItems = TRUE,
          itemtype = "2PL"
        ),
        "최대 재시도 횟수 초과 후 모델 추정에 실패했습니다. 데이터 및 파라미터를 확인하십시오."
      )
    },
    mirt = mock_mirt,
    .package = "mirt"
  )
})
