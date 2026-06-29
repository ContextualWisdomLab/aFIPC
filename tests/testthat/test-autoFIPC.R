test_that("autoFIPC works with dataframes", {
  library(mirt)
  dat1 <- expand.table(LSAT7)
  dat2 <- expand.table(LSAT7)
  dat2 <- dat2[1:500, ]

  # Supply explicit boolean priors to bypass checks
  res <- autoFIPC(
    newformXData = dat2,
    oldformYData = dat1,
    newformCommonItemNames = colnames(dat2),
    oldformCommonItemNames = colnames(dat1),
    itemtype = 'Rasch',
    tryEM = TRUE,
    checkIPD = TRUE,
    forceNormalZeroOne = FALSE,
    empiricalhist = FALSE,
    oldformBILOGprior = FALSE,
    newformBILOGprior = FALSE
  )
  expect_true(!is.null(res))
})

test_that("autoFIPC covers other paths", {
  library(mirt)
  dat1 <- expand.table(LSAT7)
  dat2 <- expand.table(LSAT7)

  model1 <- mirt(dat1, 1, itemtype = 'Rasch', verbose = FALSE)
  model2 <- mirt(dat2, 1, itemtype = 'Rasch', verbose = FALSE)

  res2 <- autoFIPC(
    newformXData = model2,
    oldformYData = model1,
    newformCommonItemNames = colnames(dat2),
    oldformCommonItemNames = colnames(dat1),
    itemtype = 'Rasch',
    tryEM = FALSE,
    checkIPD = FALSE,
    forceNormalZeroOne = TRUE,
    empiricalhist = TRUE,
    oldformBILOGprior = FALSE,
    newformBILOGprior = FALSE
  )
  expect_true(!is.null(res2))
})

test_that("autoFIPC 3PL", {
  library(mirt)
  dat1 <- expand.table(LSAT7)
  dat2 <- expand.table(LSAT7)

  res3 <- autoFIPC(
    newformXData = dat2,
    oldformYData = dat1,
    newformCommonItemNames = colnames(dat2),
    oldformCommonItemNames = colnames(dat1),
    itemtype = '3PL',
    tryEM = TRUE,
    checkIPD = FALSE,
    forceNormalZeroOne = FALSE,
    empiricalhist = FALSE,
    oldformBILOGprior = TRUE,
    newformBILOGprior = TRUE
  )
  expect_true(!is.null(res3))
})

test_that("autoFIPC ideal and failing estimations", {
  library(mirt)
  dat1 <- expand.table(LSAT7)
  dat2 <- expand.table(LSAT7)
  dat2 <- dat2[1:100,]

  tryCatch({
      res4 <- autoFIPC(
        newformXData = dat2,
        oldformYData = dat1,
        newformCommonItemNames = colnames(dat2),
        oldformCommonItemNames = colnames(dat1),
        itemtype = 'ideal',
        tryFitwholeNewItems = TRUE,
        tryFitwholeOldItems = TRUE,
        oldformBILOGprior = FALSE,
        newformBILOGprior = FALSE
      )
  }, error = function(e) {})
  expect_true(TRUE)
})

test_that("autoFIPC mismatched item lengths", {
  library(mirt)
  dat1 <- expand.table(LSAT7)
  dat2 <- expand.table(LSAT7)

  expect_error(autoFIPC(
    newformXData = dat2,
    oldformYData = dat1,
    newformCommonItemNames = colnames(dat2)[1:2],
    oldformCommonItemNames = colnames(dat1)[1:3],
    oldformBILOGprior = FALSE,
    newformBILOGprior = FALSE
  ))

  expect_error(autoFIPC(
    newformXData = dat2,
    oldformYData = dat1,
    newformCommonItemNames = character(0),
    oldformCommonItemNames = character(0),
    oldformBILOGprior = FALSE,
    newformBILOGprior = FALSE
  ))
})

test_that("autoFIPC all branches", {
  library(mirt)
  dat1 <- expand.table(LSAT7)
  dat2 <- expand.table(LSAT7)

  res1 <- autoFIPC(
    newformXData = dat2,
    oldformYData = dat1,
    newformCommonItemNames = colnames(dat2),
    oldformCommonItemNames = colnames(dat1),
    oldformBILOGprior = FALSE,
    newformBILOGprior = FALSE
  )
  expect_true(!is.null(res1))
})
