test_that("surveyFA specific branches", {
  skip_if_not_installed("mirt")

  # 1. Invalid itemtype
  expect_error(aFIPC::surveyFA(data.frame(a=c(0,1), b=c(1,0)), itemtype=c("2PL", "3PL")), "surveyFA requires itemtype to be a single non-NA character value.")
  expect_error(aFIPC::surveyFA(data.frame(a=c(0,1), b=c(1,0)), itemtype=123), "surveyFA requires itemtype to be a single non-NA character value.")

  # 2. Invalid maxItemRemovals
  expect_error(aFIPC::surveyFA(data.frame(a=c(0,1), b=c(1,0)), maxItemRemovals="3"), "surveyFA requires maxItemRemovals to be a non-negative numeric scalar.")
  expect_error(aFIPC::surveyFA(data.frame(a=c(0,1), b=c(1,0)), maxItemRemovals=-1), "surveyFA requires maxItemRemovals to be a non-negative numeric scalar.")

  # 3. Invalid pThreshold
  expect_error(aFIPC::surveyFA(data.frame(a=c(0,1), b=c(1,0)), pThreshold="0.05"), "surveyFA requires pThreshold to be in \\(0, 1\\]\\.")
  expect_error(aFIPC::surveyFA(data.frame(a=c(0,1), b=c(1,0)), pThreshold=-0.1), "surveyFA requires pThreshold to be in \\(0, 1\\]\\.")
  expect_error(aFIPC::surveyFA(data.frame(a=c(0,1), b=c(1,0)), pThreshold=1.5), "surveyFA requires pThreshold to be in \\(0, 1\\]\\.")

  # 4. forceUIRT = FALSE (triggers stop)
  expect_error(aFIPC::surveyFA(data.frame(a=c(0,1), b=c(1,0)), forceUIRT = FALSE), "surveyFA requires forceUIRT=TRUE")
})
