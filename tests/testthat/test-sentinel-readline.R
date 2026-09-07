test_that("autoFIPC strictly validates readline inputs and rejects out-of-bounds integers", {
  # Mock mirt to avoid real estimation overhead
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(data, ...) {
    mod <- methods::new("SingleGroupClass")
    mod@OptimInfo$converged <- TRUE
    mod@OptimInfo$secondordertest <- TRUE
    mod@Data$data <- data
    return(mod)
  })

  # Mock interactive to bypass non-interactive check
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  # Mock readline to return invalid inputs that previously passed regex `^[0-9]+$`
  # These include out-of-bound integer limits and invalid choices, then finally '1'
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('3', '999999999999', '0', '1'))

  newformXData <- data.frame(item1 = c(1, 0, 1), item2 = c(0, 1, 0))
  oldformYData <- data.frame(item1 = c(1, 0, 1), item2 = c(0, 1, 0))

  # The mock will trigger exactly 3 times and fail on the first 3 inputs
  # Then it throws "Too many invalid common item confirmation attempts" because we only allow 3 tries
  expect_error(
    aFIPC::autoFIPC(
      newformXData = newformXData,
      oldformYData = oldformYData,
      newformCommonItemNames = c('item1'),
      oldformCommonItemNames = c('item1'),
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})
