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

test_that("autoFIPC interactive prompts prevent NA coercion crashes and DoS vulnerabilities from large integer inputs", {

  # verify oldformBILOGprior validation protects against large integer inputs

  mockery::stub(aFIPC::autoFIPC, 'interactive', function(...) TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', function(...) "9999999999")

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      itemtype = '3PL',
      tryFitwholeNewItems = FALSE,
      tryFitwholeOldItems = FALSE,
      checkIPD = FALSE
    ),
    "Too many invalid oldform BILOG prior attempts"
  )

  # verify newformBILOGprior validation protects against large integer inputs
  mockery::stub(aFIPC::autoFIPC, 'interactive', function(...) TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', function(...) "9999999999")

  # We need oldformYData to be a model or at least have multiple categories so it bypasses failure during mirt fitting,
  # or we can mock mirt::mirt so it returns a dummy model to reach newformBILOGprior check.
  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mod@OptimInfo$secondordertest <- TRUE
  mod@Data$data <- data.frame(A=c(1,0))
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) mod)
  mockery::stub(aFIPC::autoFIPC, 'surveyFA', function(...) mod)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=c(1,0)),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE,
      oldformBILOGprior = TRUE,
      itemtype = '3PL',
      tryFitwholeNewItems = FALSE,
      tryFitwholeOldItems = FALSE,
      checkIPD = FALSE
    ),
    "Too many invalid newform BILOG prior attempts"
  )

  # verify confirmCommonItems validation protects against large integer inputs
  mockery::stub(aFIPC::autoFIPC, 'interactive', function(...) TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', function(...) "9999999999")
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = '3PL',
      tryFitwholeNewItems = FALSE,
      tryFitwholeOldItems = FALSE,
      checkIPD = FALSE
    ),
    "Too many invalid common item confirmation attempts"
  )
})
