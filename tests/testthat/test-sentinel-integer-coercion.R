test_that("interactive readline valid inputs", {
  # For valid inputs, it should correctly parse the '1' and eventually hit the estimation
  # We test the prompt reading by providing minimal data that causes mirt to fail early
  # but after the prompt logic.

  mock_readline_confirm <- mockery::mock('1')
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline_confirm)

  # A 100x4 matrix works better to avoid degrees of freedom errors in some cases,
  # but our goal is just to pass the `checkCorrect()` prompt logic.
  expect_error(
    aFIPC::autoFIPC(
      newformXData = matrix(sample(c(0,1), 1000, replace=T), ncol=10, dimnames=list(NULL, paste0('I',1:10))),
      oldformYData = matrix(sample(c(0,1), 1000, replace=T), ncol=10, dimnames=list(NULL, paste0('I',1:10))),
      newformCommonItemNames = 'I1',
      oldformCommonItemNames = 'I1',
      itemtype = '3PL',
      newformBILOGprior = TRUE,
      oldformBILOGprior = TRUE,
      confirmCommonItems = NULL
    )
  )
})

test_that("interactive readline invalid inputs", {
  # Mock invalid inputs
  mock_readline_invalid <- mockery::mock('3', 'a', '9999999999999999999999999999999', cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mock_readline_invalid)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = matrix(sample(c(0,1), 1000, replace=T), ncol=10, dimnames=list(NULL, paste0('I',1:10))),
      oldformYData = matrix(sample(c(0,1), 1000, replace=T), ncol=10, dimnames=list(NULL, paste0('I',1:10))),
      newformCommonItemNames = 'I1',
      oldformCommonItemNames = 'I1',
      itemtype = '3PL',
      newformBILOGprior = NULL,
      oldformBILOGprior = TRUE,
      confirmCommonItems = TRUE
    ),
    "Too many invalid newform BILOG prior attempts"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = matrix(sample(c(0,1), 1000, replace=T), ncol=10, dimnames=list(NULL, paste0('I',1:10))),
      oldformYData = matrix(sample(c(0,1), 1000, replace=T), ncol=10, dimnames=list(NULL, paste0('I',1:10))),
      newformCommonItemNames = 'I1',
      oldformCommonItemNames = 'I1',
      itemtype = '3PL',
      newformBILOGprior = TRUE,
      oldformBILOGprior = NULL,
      confirmCommonItems = TRUE
    ),
    "Too many invalid oldform BILOG prior attempts"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = matrix(sample(c(0,1), 1000, replace=T), ncol=10, dimnames=list(NULL, paste0('I',1:10))),
      oldformYData = matrix(sample(c(0,1), 1000, replace=T), ncol=10, dimnames=list(NULL, paste0('I',1:10))),
      newformCommonItemNames = 'I1',
      oldformCommonItemNames = 'I1',
      itemtype = '3PL',
      newformBILOGprior = TRUE,
      oldformBILOGprior = TRUE,
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})
