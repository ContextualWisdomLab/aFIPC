test_that("autoFIPC raises error in non-interactive session for inputs", {
  # interactive() should be FALSE by default in testthat environments
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Common item confirmation requires an interactive session"
  )
})

test_that("autoFIPC does not implicitly approve supplied common items", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = FALSE
    ),
    "Please write down pairs correctly"
  )
})

test_that("autoFIPC validates input types securely", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = 1,
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Security Error: newformXData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = 123,
      oldformCommonItemNames = c('A')
    ),
    "Security Error: newformCommonItemNames must be a character vector"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = c("3PL", "2PL")
    ),
    "Security Error: itemtype must be length 1 or length 1 \\(number of items\\)."
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = structure(list(), class = "SingleGroupClass"),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE
    ),
    "Security Error: oldformYData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryFitwholeNewItems = "TRUE"
    ),
    "Security Error: tryFitwholeNewItems must be a single non-NA logical value"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryEM = NA
    ),
    "Security Error: tryEM must be a single non-NA logical value"
  )
})

test_that("autoFIPC handles matrix inputs correctly and processes ncol without as.data.frame", {
  skip_if_not_installed("mockery")

  mat_new <- matrix(1:4, ncol=2)
  colnames(mat_new) <- c("A", "B")
  mat_old <- matrix(1:4, ncol=2)
  colnames(mat_old) <- c("A", "B")

  # mirt::mirt의 느린 실행을 방지하기 위한 mock 생성
  mockery::stub(autoFIPC, 'mirt::mirt', function(data, ...) {
    mod <- new("SingleGroupClass")
    mod@OptimInfo$converged <- TRUE
    mod@OptimInfo$secondordertest <- TRUE
    mod@Data$data <- as.data.frame(data)
    return(mod)
  })

  mockery::stub(autoFIPC, 'interactive', function() TRUE)

  # ncol(matrix)이 정상적으로 동작하여 nItems가 올바르게 세팅되는지 확인하기 위해
  # 일부러 itemtype 길이를 안맞게 하여 에러를 유발시키고 에러 메시지를 검증
  expect_error(
    aFIPC::autoFIPC(
      newformXData = mat_new,
      oldformYData = mat_old,
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = c("2PL", "2PL", "2PL"), # 의도적인 에러 유발 (길이가 nItems와 불일치)
      confirmCommonItems = TRUE
    ),
    "Security Error: itemtype must be length 1 or length 2 \\(number of items\\)."
  )
})
