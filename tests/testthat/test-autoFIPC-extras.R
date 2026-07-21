test_that("autoFIPC specific error paths", {
  skip_if_not_installed("mirt")

  # oldformBILOGprior must be logical
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      oldformBILOGprior = "TRUE"
    ),
    "Security Error: oldformBILOGprior must be a single non-NA logical value or NULL"
  )

  # tryFitwholeOldItems must be logical
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryFitwholeOldItems = "TRUE"
    ),
    "Security Error: tryFitwholeOldItems must be a single non-NA logical value"
  )

  # checkIPD must be logical
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      checkIPD = "TRUE"
    ),
    "Security Error: checkIPD must be a single non-NA logical value"
  )

  # freeMEAN must be logical
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      freeMEAN = "TRUE"
    ),
    "Security Error: freeMEAN must be a single non-NA logical value"
  )

  # forceNormalZeroOne must be logical
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      forceNormalZeroOne = "TRUE"
    ),
    "Security Error: forceNormalZeroOne must be a single non-NA logical value"
  )

  # parameterOverwrite must be logical
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      parameterOverwrite = "TRUE"
    ),
    "Security Error: parameterOverwrite must be a single non-NA logical value"
  )

  # empiricalhist must be logical
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      empiricalhist = "TRUE"
    ),
    "Security Error: empiricalhist must be a single non-NA logical value"
  )

  # Unequal common items
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A', 'B'),
      oldformCommonItemNames = c('A')
    ),
    "Common Items are not equal"
  )

  # 0 length common items
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = character(0),
      oldformCommonItemNames = character(0)
    ),
    "Please provide common item names"
  )
})
