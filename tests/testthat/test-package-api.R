test_that("autoFIPC is exported", {
  expect_true("autoFIPC" %in% getNamespaceExports("aFIPC"))
  expect_true(is.function(aFIPC::autoFIPC))
})
