test_that("interactive prompts strictly validate input and prevent integer overflow", {
  df_x <- data.frame(A = c(1,0,1,0), B = c(1,0,1,0))
  df_y <- data.frame(A = c(1,0,1,0), C = c(1,0,1,0))

  mockery::stub(aFIPC::autoFIPC, "interactive", function() TRUE)
  mockery::stub(aFIPC::autoFIPC, "readline", mockery::mock("999999999999999999999", "3", "abc", cycle = TRUE))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = df_x,
      oldformYData = df_y,
      newformCommonItemNames = "A",
      oldformCommonItemNames = "A",
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})
