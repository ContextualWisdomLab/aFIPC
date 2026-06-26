test_that("autoFIPC is exported", {
  expect_true("autoFIPC" %in% getNamespaceExports("aFIPC"))
  expect_true(is.function(aFIPC::autoFIPC))
})

test_that("autoFIPC fails securely in non-interactive environment", {
  expect_false(interactive())
  expect_error(
    aFIPC::autoFIPC(
      newformXData = matrix(1, 10, 5),
      oldformYData = matrix(1, 10, 5),
      newformCommonItemNames = "Item1",
      oldformCommonItemNames = "Item1"
    ),
    "Interactive prompt is not available"
  )
})
