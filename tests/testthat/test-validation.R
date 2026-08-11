library(testthat)
library(mockery)

test_that("weak regex is bounded properly", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  m_readline <- mockery::mock('3', '3', '3')
  mockery::stub(aFIPC::autoFIPC, 'readline', m_readline)

  # Stub mirt to avoid estimation error and just get to validation
  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', mod)

  dummy_data <- data.frame(v1=c(0,1,0,1,1), v2=c(1,0,1,0,0), v3=c(1,1,0,0,1))

  expect_error(
    aFIPC::autoFIPC(
      oldformYData = dummy_data,
      newformXData = dummy_data,
      oldformCommonItemNames = c("v1"),
      newformCommonItemNames = c("v1")
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("weak regex is bounded properly for oldform BILOG prior", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  m_readline <- mockery::mock('1', '3', '3', '3')
  mockery::stub(aFIPC::autoFIPC, 'readline', m_readline)

  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', mod)

  dummy_data <- data.frame(v1=c(0,1,0,1,1), v2=c(1,0,1,0,0), v3=c(1,1,0,0,1))

  expect_error(
    aFIPC::autoFIPC(
      oldformYData = dummy_data,
      newformXData = dummy_data,
      itemtype = '3PL',
      oldformCommonItemNames = c("v1"),
      newformCommonItemNames = c("v1")
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("weak regex is bounded properly for newform BILOG prior", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)

  m_readline <- mockery::mock('1', '1', '3', '3', '3')
  mockery::stub(aFIPC::autoFIPC, 'readline', m_readline)

  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', mod)

  dummy_data <- data.frame(v1=c(0,1,0,1,1), v2=c(1,0,1,0,0), v3=c(1,1,0,0,1))

  expect_error(
    aFIPC::autoFIPC(
      oldformYData = dummy_data,
      newformXData = dummy_data,
      itemtype = '3PL',
      oldformCommonItemNames = c("v1"),
      newformCommonItemNames = c("v1")
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
