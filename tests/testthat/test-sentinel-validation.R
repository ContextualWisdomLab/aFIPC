test_that("autoFIPC validates boolean flags for newformBILOGprior, oldformBILOGprior, and confirmCommonItems", {
  # newformBILOGprior
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

  # oldformBILOGprior
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

  # confirmCommonItems
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

test_that("autoFIPC handles interactive confirmCommonItems readline DoS inputs correctly", {
  # Mock interactive() and readline() to simulate abnormally large integer input that used to coerce to NA
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('9999999999999999999', '9999999999999999999', '9999999999999999999'))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(item1 = c(1,0,1)),
      oldformYData = data.frame(item1 = c(1,1,0)),
      newformCommonItemNames = c('item1'),
      oldformCommonItemNames = c('item1'),
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("autoFIPC handles interactive oldformBILOGprior readline DoS inputs correctly", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('1', '9999999999999999999', '9999999999999999999', '9999999999999999999'))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(item1 = c(1,0,1)),
      oldformYData = data.frame(item1 = c(1,1,0)),
      newformCommonItemNames = c('item1'),
      oldformCommonItemNames = c('item1'),
      confirmCommonItems = NULL,
      itemtype = '3PL',
      oldformBILOGprior = NULL
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("autoFIPC handles interactive newformBILOGprior readline DoS inputs correctly", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  mockery::stub(aFIPC::autoFIPC, 'readline', mockery::mock('1', '1', '9999999999999999999', '9999999999999999999', '9999999999999999999'))

  # Stub out mirt::mirt but instead of failing with an error, return a proper S4 object Mock
  mockClass <- setClass("MockClass", slots=c(OptimInfo="list"))

  mock_mirt <- function(data, model, itemtype, ...) {
    if (identical(data, data.frame(item1 = c(1,1,0)))) {
      return(mockClass(OptimInfo=list(secondordertest=TRUE)))
    }
    stop('Should not reach here')
  }

  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', mock_mirt)

  mockery::stub(aFIPC::autoFIPC, 'mirt::extract.mirt', function(...) data.frame(a1=1, d=0, g=0, u=1))
  mockery::stub(aFIPC::autoFIPC, 'mirt::coef', function(...) list(item1=c(a1=1, d=0, g=0, u=1)))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(item1 = c(1,0,1)),
      oldformYData = data.frame(item1 = c(1,1,0)),
      newformCommonItemNames = c('item1'),
      oldformCommonItemNames = c('item1'),
      confirmCommonItems = NULL,
      itemtype = '3PL',
      oldformBILOGprior = NULL,
      newformBILOGprior = NULL
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
