test_that("autoFIPC banner reports the installed package version", {
  messages <- character()

  expect_error(
    withCallingHandlers(
      aFIPC::autoFIPC(
        newformXData = NULL,
        oldformYData = NULL,
        newformCommonItemNames = character(),
        oldformCommonItemNames = character()
      ),
      message = function(condition) {
        messages <<- c(messages, conditionMessage(condition))
        invokeRestart("muffleMessage")
      }
    ),
    "newformXData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_gte(length(messages), 1L)
  expect_identical(
    messages[[1]],
    paste0(
      "automated Fixed Item Parameter Calibration: aFIPC ",
      as.character(utils::packageVersion("aFIPC"))
    )
  )
})
