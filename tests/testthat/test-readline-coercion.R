test_that("interactive prompt handles large numbers correctly without crashing", {
  # We mock readline to return a huge number that coerces to NA
  my_readline <- function(...) "9999999999999999999999999"
  mockery::stub(aFIPC::autoFIPC, 'readline', my_readline)
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
