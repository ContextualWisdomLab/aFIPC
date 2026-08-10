test_that("Sentinel: Interactive prompts strictly validate inputs to prevent integer overflow DoS", {
  mock_readline <- mockery::mock("99999999999999999", "3", "4")

  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline)
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Too many invalid common item confirmation attempts"
  )
})
