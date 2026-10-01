library(testthat)
library(mockery)

test_that("autoFIPC validates boolean parameters correctly", {
  dummy_model <- mirt::mirt(data.frame(Item1=c(0,1,1,0,0,1,1,0), Item2=c(1,0,0,1,1,0,0,1), Item3=c(1,1,0,0,1,0,1,0), Item4=c(0,0,1,1,0,1,0,1)), 1, TOL=NA, iter=0)

  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", newformBILOGprior="TRUE"),
    "Security Error: newformBILOGprior must be a single non-NA logical value or NULL"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", oldformBILOGprior="TRUE"),
    "Security Error: oldformBILOGprior must be a single non-NA logical value or NULL"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", confirmCommonItems="TRUE"),
    "Security Error: confirmCommonItems must be a single non-NA logical value or NULL"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", tryFitwholeNewItems="TRUE"),
    "Security Error: tryFitwholeNewItems must be a single non-NA logical value"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", tryFitwholeOldItems="TRUE"),
    "Security Error: tryFitwholeOldItems must be a single non-NA logical value"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", checkIPD="TRUE"),
    "Security Error: checkIPD must be a single non-NA logical value"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", tryEM="TRUE"),
    "Security Error: tryEM must be a single non-NA logical value"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", freeMEAN="TRUE"),
    "Security Error: freeMEAN must be a single non-NA logical value"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", forceNormalZeroOne="TRUE"),
    "Security Error: forceNormalZeroOne must be a single non-NA logical value"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", parameterOverwrite="TRUE"),
    "Security Error: parameterOverwrite must be a single non-NA logical value"
  )
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", empiricalhist="TRUE"),
    "Security Error: empiricalhist must be a single non-NA logical value"
  )
})

test_that("autoFIPC integer overflow check validation", {
  dummy_model <- mirt::mirt(data.frame(Item1=c(0,1,1,0,0,1,1,0), Item2=c(1,0,0,1,1,0,0,1), Item3=c(1,1,0,0,1,0,1,0), Item4=c(0,0,1,1,0,1,0,1)), 1, TOL=NA, iter=0)

  m1 <- mock(FALSE, cycle = TRUE)
  m2 <- mock("1", cycle = TRUE)
  m3 <- mock("2", cycle = TRUE)
  m4 <- mock("invalid", "invalid", "invalid", cycle = TRUE)

  stub(autoFIPC, "interactive", m1)
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", confirmCommonItems=NULL),
    "Common item confirmation requires an interactive session; "
  )

  stub(autoFIPC, "interactive", mock(TRUE, cycle = TRUE))
  stub(autoFIPC, "readline", m2)
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", confirmCommonItems=NULL, tryFitwholeOldItems=F, tryFitwholeNewItems=F, checkIPD="TRUE"),
    "Security Error: checkIPD must be a single non-NA logical value"
  )

  stub(autoFIPC, "readline", m3)
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", confirmCommonItems=NULL),
    "Please write down pairs correctly"
  )

  stub(autoFIPC, "readline", m4)
  expect_error(
    autoFIPC(dummy_model, dummy_model, "Item1", "Item1", confirmCommonItems=NULL),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("autoFIPC integer overflow check validation - oldformBILOGprior", {
  # dummy df
  dummy_df <- data.frame(Item1=c(0,1,1,0,0,1,1,0), Item2=c(1,0,0,1,1,0,0,1), Item3=c(1,1,0,0,1,0,1,0), Item4=c(0,0,1,1,0,1,0,1))
  dummy_model <- mirt::mirt(dummy_df, 1, TOL=NA, iter=0)

  stub(autoFIPC, "interactive", mock(FALSE, cycle = TRUE))
  expect_error(
    autoFIPC(dummy_model, dummy_df, "Item1", "Item1", confirmCommonItems=TRUE, oldformBILOGprior=NULL, tryFitwholeOldItems=T, tryFitwholeNewItems=F),
    "Interactive session required for oldform BILOG prior"
  )

  stub(autoFIPC, "interactive", mock(TRUE, cycle = TRUE))

  stub(autoFIPC, "readline", mock("1", cycle = TRUE))

  # Stub mirt to prevent estimation error
  stub(autoFIPC, "mirt::mirt", mock(dummy_model, cycle = TRUE))

  expect_error(
    autoFIPC(dummy_model, dummy_df, "Item1", "Item1", confirmCommonItems=TRUE, oldformBILOGprior=NULL, tryFitwholeOldItems=F, tryFitwholeNewItems=F, checkIPD="TRUE"),
    "Security Error: checkIPD must be a single non-NA logical value"
  )

  stub(autoFIPC, "readline", mock("invalid", "invalid", "invalid", cycle = TRUE))
  expect_error(
    autoFIPC(dummy_model, dummy_df, "Item1", "Item1", confirmCommonItems=TRUE, oldformBILOGprior=NULL, tryFitwholeOldItems=F, tryFitwholeNewItems=F),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("autoFIPC integer overflow check validation - newformBILOGprior", {
  dummy_df <- data.frame(Item1=c(0,1,1,0,0,1,1,0), Item2=c(1,0,0,1,1,0,0,1), Item3=c(1,1,0,0,1,0,1,0), Item4=c(0,0,1,1,0,1,0,1))
  dummy_model <- mirt::mirt(dummy_df, 1, TOL=NA, iter=0)

  stub(autoFIPC, "interactive", mock(FALSE, cycle = TRUE))
  expect_error(
    autoFIPC(dummy_df, dummy_model, "Item1", "Item1", confirmCommonItems=TRUE, newformBILOGprior=NULL, tryFitwholeOldItems=F, tryFitwholeNewItems=T),
    "Interactive session required for newform BILOG prior"
  )

  stub(autoFIPC, "interactive", mock(TRUE, cycle = TRUE))

  stub(autoFIPC, "readline", mock("1", cycle = TRUE))

  # Stub mirt to prevent estimation error
  stub(autoFIPC, "mirt::mirt", mock(dummy_model, cycle = TRUE))

  expect_error(
    autoFIPC(dummy_df, dummy_model, "Item1", "Item1", confirmCommonItems=TRUE, newformBILOGprior=NULL, tryFitwholeOldItems=F, tryFitwholeNewItems=F, checkIPD="TRUE"),
    "Security Error: checkIPD must be a single non-NA logical value"
  )

  stub(autoFIPC, "readline", mock("invalid", "invalid", "invalid", cycle = TRUE))
  expect_error(
    autoFIPC(dummy_df, dummy_model, "Item1", "Item1", confirmCommonItems=TRUE, newformBILOGprior=NULL, tryFitwholeOldItems=F, tryFitwholeNewItems=F),
    "Too many invalid newform BILOG prior attempts"
  )
})
