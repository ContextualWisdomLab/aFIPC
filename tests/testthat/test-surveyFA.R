test_that("surveyFA fallback fails explicitly until implemented", {
  expect_error(
    aFIPC::surveyFA(data.frame(item1 = c(0, 1, 1, 0))),
    "surveyFA fallback is not implemented"
  )
})
