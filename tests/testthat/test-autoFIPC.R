test_that("autoFIPC non-interactive prompts handled correctly", {
  # Mock Science dataset from mirt package
  suppressMessages(library(mirt))
  data(Science)

  # subset to create oldform and newform
  oldform <- Science[1:100, 1:3]
  newform <- Science[101:200, 2:4]

  # Common items: 2 and 3
  # Variable names
  oldformCommon <- colnames(oldform)[2:3]
  newformCommon <- colnames(newform)[1:2]

  # Run autoFIPC non-interactively
  # The test will hang if interactive() checks are not working
  # Also set parameterOverwrite = TRUE/FALSE maybe not needed
  expect_error(
    res <- autoFIPC(
      newformXData = newform,
      oldformYData = oldform,
      newformCommonItemNames = newformCommon,
      oldformCommonItemNames = oldformCommon,
      itemtype = 'Rasch',
      tryFitwholeNewItems = FALSE,
      tryFitwholeOldItems = FALSE,
      checkIPD = FALSE,
      tryEM = FALSE,
      freeMEAN = FALSE,
      forceNormalZeroOne = FALSE,
      empiricalhist = FALSE
    ),
    NA
  )

  expect_true(!is.null(res))
})
