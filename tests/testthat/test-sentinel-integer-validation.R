test_that("autoFIPC integer overflow in readline input parsing is prevented", {
  # Provide small dataset
  dummy_data <- data.frame(
    Item1 = c(1, 0, 1, 0, 1, 1),
    Item2 = c(0, 1, 0, 1, 0, 0),
    Item3 = c(0, 0, 1, 1, 0, 0),
    Item4 = c(1, 1, 0, 0, 1, 1)
  )

  # Mock interactive to return TRUE
  mockery::stub(aFIPC::autoFIPC, "interactive", function() TRUE)

  # Mock readline to return a huge number first, then a valid "1"
  mockery::stub(aFIPC::autoFIPC, "readline", mockery::mock("100000000000000", "1", cycle = TRUE))

  # As we fixed the bug, it won't crash with "missing value where TRUE/FALSE needed" NA coercion error.
  # We use try() to catch whatever it does down the line (which is estimation failing).
  expect_error(
    aFIPC::autoFIPC(
      newformXData = dummy_data,
      oldformYData = dummy_data,
      newformCommonItemNames = "Item1",
      oldformCommonItemNames = "Item1",
      confirmCommonItems = NULL
    ), regexp = "completely failed|could not estimate"
  )
})
