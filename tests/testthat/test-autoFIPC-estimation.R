test_that("autoFIPC initial estimation failure", {
  skip_if_not_installed("mirt")
  skip_if_not_installed("mockery")

  # Stub mirt::mirt so it just returns a string, making `isRealMirtModel` and `exists` checks work or fail in specific ways
  m_fail <- function(...) stop("forced failure")
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', m_fail)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=c(1,1,1), B=c(0,0,0)),
      oldformYData = data.frame(A=c(1,1,1), B=c(0,0,0)),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = '2PL',
      confirmCommonItems = TRUE
    ),
    "Security Error: Initial estimation of oldFormModel completely failed"
  )
})

test_that("autoFIPC newform initial estimation failure", {
  skip_if_not_installed("mirt")
  skip_if_not_installed("mockery")

  set.seed(1)
  dat_old <- mirt::simdata(a=matrix(c(1,1,1,1)), d=matrix(c(0,0,0,0)), N=100, itemtype="2PL")
  colnames(dat_old) <- c("A", "B", "C", "D")
  old_mod <- mirt::mirt(dat_old, 1, itemtype="2PL", SE=FALSE, verbose=FALSE)

  m_fail <- function(...) stop("forced failure")
  mockery::stub(aFIPC::autoFIPC, 'mirt::mirt', m_fail)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = dat_old,
      oldformYData = old_mod,
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = '2PL',
      confirmCommonItems = TRUE
    ),
    "Security Error: Initial estimation of newFormModel completely failed"
  )
})
