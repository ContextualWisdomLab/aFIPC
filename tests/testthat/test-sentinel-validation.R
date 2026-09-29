test_that("autoFIPC validates boolean flags for newformBILOGprior, oldformBILOGprior, and confirmCommonItems", {
  # newformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      newformBILOGprior = "TRUE"
    ),
    "Security Error: newformBILOGprior must be a single non-NA logical value or NULL"
  )

  # oldformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      oldformBILOGprior = c(TRUE, FALSE)
    ),
    "Security Error: oldformBILOGprior must be a single non-NA logical value or NULL"
  )

  # confirmCommonItems
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NA
    ),
    "Security Error: confirmCommonItems must be a single non-NA logical value or NULL"
  )
})

test_that("aFIPC handles non-interactive prompt fallbacks and validates input safely to avoid integer overflow", {
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

test_that("promptUserConfirm safely validates interactive numeric inputs and avoids integer coercion overflow", {
  prompt_func <- aFIPC:::promptUserConfirm

  # 1) Boundary check: Valid "1"
  expect_identical(prompt_func("test?", .interactive = function() TRUE, .readline = function(...) "1"), 1L)

  # 2) Boundary check: Valid "2"
  expect_identical(prompt_func("test?", .interactive = function() TRUE, .readline = function(...) "2"), 2L)

  # 3) Invalid check: Giant string
  expect_error(prompt_func("test?", .interactive = function() TRUE, .readline = function(...) "999999999999999999999999999999999999999999999999999999999"), "Too many invalid attempts")

  # 4) Invalid check: Signed/whitespace inputs
  expect_error(prompt_func("test?", .interactive = function() TRUE, .readline = function(...) " 1 "), "Too many invalid attempts")
})
