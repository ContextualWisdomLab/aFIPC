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

test_that("autoFIPC strictly validates readline inputs using exact bounds", {
  dummy_mod <- function(...) {
    mod <- new("SingleGroupClass")
    mod@OptimInfo$converged <- TRUE
    mod@OptimInfo$secondordertest <- TRUE
    mod@Data$data <- data.frame(A=1, B=2)
    return(mod)
  }

  mockery::stub(autoFIPC, "mirt::mirt", dummy_mod)
  mockery::stub(autoFIPC, "interactive", function() TRUE)
  mockery::stub(autoFIPC, "readline", mockery::mock("33333333333", "33333333", "2"))

  expect_error(
    expect_message(
      autoFIPC(
        newformXData = data.frame(A=1, B=2),
        oldformYData = data.frame(A=1, B=2),
        newformCommonItemNames = c('A'),
        oldformCommonItemNames = c('A'),
        confirmCommonItems = NULL
      ),
      "Checking correspond common item names"
    ),
    "Please write down pairs correctly"
  )
})

test_that("autoFIPC strictly validates oldformBILOGprior and newformBILOGprior using exact bounds", {
  dummy_mod <- function(...) {
    mod <- new("SingleGroupClass")
    mod@OptimInfo$converged <- TRUE
    mod@OptimInfo$secondordertest <- TRUE
    mod@Data$data <- data.frame(A=1, B=2)
    return(mod)
  }

  mockery::stub(autoFIPC, "mirt::mirt", dummy_mod)
  mockery::stub(autoFIPC, "interactive", function() TRUE)
  mockery::stub(autoFIPC, "readline", mockery::mock("1", "3333333", "333333", "3333333", "33333333"))

  expect_error(
    autoFIPC(
      newformXData = data.frame(A=1, B=2),
      oldformYData = data.frame(A=1, B=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      oldformBILOGprior = NULL,
      newformBILOGprior = NULL,
      confirmCommonItems = NULL
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})
