test_that("autoFIPC validates readline input for confirmation prompt to prevent coercion vulnerabilities", {
  skip_if_not_installed("mockery")

  old_model <- mirt::mirt(
    data.frame(item1 = c(0, 1, 0, 1, 0), item2 = c(1, 0, 1, 0, 1), item3 = c(0, 0, 1, 1, 0)),
    model = 1,
    itemtype = "2PL",
    SE = FALSE,
    verbose = FALSE
  )
  new_model <- mirt::mirt(
    data.frame(item1 = c(1, 1, 0, 0, 1), item2 = c(0, 0, 1, 1, 0), item4 = c(1, 0, 0, 1, 1)),
    model = 1,
    itemtype = "2PL",
    SE = FALSE,
    verbose = FALSE
  )

  # Mock interactive mode
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)

  # RED test condition: existing grepl implementation would accept 3 and 9999999999999999999
  # GREEN test condition: we provide "3", then an oversized integer string, and finally a valid "1"
  mock_readline <- mockery::mock("3", "9999999999999999999", "1", cycle = FALSE)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline)

  # Suppress the message and test for autoFIPC execution without crash
  suppressMessages({
    # Expect error because the old/new models only have 3 items each and test data is small,
    # leading to "Too few degrees of freedom", BUT we ensure the error is NOT about coercion/NA
    expect_error(
      aFIPC::autoFIPC(
        newformXData = new_model,
        oldformYData = old_model,
        newformCommonItemNames = c("item1", "item2"),
        oldformCommonItemNames = c("item1", "item2"),
        confirmCommonItems = NULL,
        itemtype = "2PL"
      ),
      "Too few degrees of freedom" # We expect the estimation to start and fail for DOF, proving we bypassed the readline crash
    )
  })
})
