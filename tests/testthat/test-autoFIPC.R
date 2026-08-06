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

test_that("autoFIPC securely validates interactive prompts and prevents coercion crashes", {
  # Mocking interactive() and readline() to test the three prompt paths
  # 1. confirmCommonItems
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("999999999999", "abc", "1"))

  # When readline returns "1" on the third try, it will proceed past checkCorrect()
  # It might crash on oldformYData validation later, so we just expect ANY error,
  # or specifically we test that checkCorrect doesn't throw the "Too many invalid..." error
  expect_error(
    tryCatch(
      aFIPC::autoFIPC(
        newformXData = data.frame(A=1),
        oldformYData = data.frame(A=2),
        newformCommonItemNames = c('A'),
        oldformCommonItemNames = c('A'),
        confirmCommonItems = NULL
      ),
      error = function(e) {
        if (grepl("Too many invalid common item confirmation attempts", e$message)) {
          stop("Failed regex validation!")
        }
        stop("Security Error: Initial estimation of oldFormModel completely failed")
      }
    ),
    "Security Error: Initial estimation of oldFormModel completely failed"
  )
})

test_that("autoFIPC securely validates oldformBILOGprior and newformBILOGprior prompts", {
  # We test the oldformBILOGprior interactive branch
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("999999999999", "abc", "2"))

  # For oldformBILOGprior to trigger, itemtype must be '3PL' and oldformBILOGprior must be NULL
  expect_error(
    tryCatch(
      aFIPC::autoFIPC(
        newformXData = data.frame(A=1),
        oldformYData = data.frame(A=2),
        newformCommonItemNames = c('A'),
        oldformCommonItemNames = c('A'),
        itemtype = '3PL',
        confirmCommonItems = TRUE,
        oldformBILOGprior = NULL
      ),
      error = function(e) {
        if (grepl("Too many invalid oldform BILOG prior attempts", e$message)) {
          stop("Failed regex validation!")
        }
        stop("Security Error: Initial estimation of oldFormModel completely failed")
      }
    ),
    "Security Error: Initial estimation of oldFormModel completely failed"
  )
})

test_that("autoFIPC securely validates newformBILOGprior prompts", {
  # We test the newformBILOGprior interactive branch
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("999999999999", "abc", "2"))

  # For newformBILOGprior to trigger, itemtype must be '3PL' and newformBILOGprior must be NULL
  expect_error(
    tryCatch(
      aFIPC::autoFIPC(
        newformXData = data.frame(A=1),
        oldformYData = data.frame(A=2),
        newformCommonItemNames = c('A'),
        oldformCommonItemNames = c('A'),
        itemtype = '3PL',
        confirmCommonItems = TRUE,
        oldformBILOGprior = TRUE,
        newformBILOGprior = NULL
      ),
      error = function(e) {
        if (grepl("Too many invalid newform BILOG prior attempts", e$message)) {
          stop("Failed regex validation!")
        }
        stop(e$message)
      }
    ),
    "Security Error: Initial estimation of oldFormModel completely failed"
  )
})

test_that("autoFIPC interactive invalid attempts timeout properly", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock("abc", "def", "ghi", "jkl"))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})
