test_that("autoFIPC validates boolean flags for newformBILOGprior, oldformBILOGprior, and confirmCommonItems", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      newformBILOGprior = "TRUE"
    ),
    "Security Error: newformBILOGprior must be a single non-NA logical value or NULL"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      oldformBILOGprior = c(TRUE, FALSE)
    ),
    "Security Error: oldformBILOGprior must be a single non-NA logical value or NULL"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NA
    ),
    "Security Error: confirmCommonItems must be a single non-NA logical value or NULL"
  )
})

test_that("common-item confirmation admits only exact menu choices", {
  new_df <- data.frame(A=c(1,0,1))
  old_df <- data.frame(A=c(1,1,0))

  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  for (answers in list(c('0', '3', '12'), c(' 1', 'a', '2147483648'))) {
    mockery::stub(aFIPC::autoFIPC, 'readline', do.call(mockery::mock, as.list(answers)))
    expect_error(
      aFIPC::autoFIPC(
        newformXData = new_df,
        oldformYData = old_df,
        newformCommonItemNames = 'A',
        oldformCommonItemNames = 'A',
        itemtype = '2PL',
        confirmCommonItems = NULL
      ),
      "Too many invalid common item confirmation attempts"
    )
  }

  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('2'))
  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_df,
      oldformYData = old_df,
      newformCommonItemNames = 'A',
      oldformCommonItemNames = 'A',
      itemtype = '2PL',
      confirmCommonItems = NULL
    ),
    "Please write down pairs correctly"
  )

  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) stop('forced post-confirmation failure'))
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('1'))
  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_df,
      oldformYData = old_df,
      newformCommonItemNames = 'A',
      oldformCommonItemNames = 'A',
      itemtype = '2PL',
      confirmCommonItems = NULL
    ),
    "Security Error: Initial estimation of oldFormModel completely failed"
  )
})

test_that("oldform BILOG prompt admits only exact menu choices", {
  new_df <- data.frame(A=c(1,0,1))
  old_df <- data.frame(A=c(1,1,0))

  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  for (answers in list(c('0', '3', '12'), c(' 1', 'a', '2147483648'))) {
    mockery::stub(aFIPC::autoFIPC, 'readline', do.call(mockery::mock, as.list(answers)))
    expect_error(
      aFIPC::autoFIPC(
        newformXData = new_df,
        oldformYData = old_df,
        newformCommonItemNames = 'A',
        oldformCommonItemNames = 'A',
        confirmCommonItems = TRUE,
        itemtype = '3PL',
        oldformBILOGprior = NULL
      ),
      "Too many invalid oldform BILOG prior attempts"
    )
  }

  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt.model', function(...) 1)
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) stop('forced post-prior failure'))
  for (answer in c('1', '2')) {
    mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock(answer))
    expect_error(
      aFIPC::autoFIPC(
        newformXData = new_df,
        oldformYData = old_df,
        newformCommonItemNames = 'A',
        oldformCommonItemNames = 'A',
        confirmCommonItems = TRUE,
        itemtype = '3PL',
        oldformBILOGprior = NULL
      ),
      "Security Error: Initial estimation of oldFormModel completely failed"
    )
  }
})

test_that("newform BILOG prompt admits only exact menu choices", {
  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mod@OptimInfo$secondordertest <- TRUE

  new_df <- data.frame(A=c(1,0,1))
  old_df <- data.frame(A=c(1,1,0))

  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'surveyFA', function(...) stop('forced failure'))
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt.model', function(...) 1)

  for (answers in list(c('0', '3', '12'), c(' 1', 'a', '2147483648'))) {
    mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) mod)
    mockery::stub(aFIPC::autoFIPC, 'readline', do.call(mockery::mock, as.list(answers)))
    expect_error(
      aFIPC::autoFIPC(
        newformXData = new_df,
        oldformYData = old_df,
        newformCommonItemNames = 'A',
        oldformCommonItemNames = 'A',
        confirmCommonItems = TRUE,
        itemtype = '3PL',
        newformBILOGprior = NULL,
        oldformBILOGprior = TRUE
      ),
      "Too many invalid newform BILOG prior attempts"
    )
  }

  for (answer in c('1', '2')) {
    mirt_calls <- 0L
    mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', function(...) {
      mirt_calls <<- mirt_calls + 1L
      if (mirt_calls == 1L) return(mod)
      stop('forced post-prior failure')
    })
    mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock(answer))
    expect_error(
      aFIPC::autoFIPC(
        newformXData = new_df,
        oldformYData = old_df,
        newformCommonItemNames = 'A',
        oldformCommonItemNames = 'A',
        confirmCommonItems = TRUE,
        itemtype = '3PL',
        newformBILOGprior = NULL,
        oldformBILOGprior = TRUE
      ),
      "Security Error: Initial estimation of newFormModel completely failed"
    )
  }
})
