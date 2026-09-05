test_that("common-item confirmation accepts only documented menu choices", {
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  oversized_number <- paste(rep("9", 1000), collapse = "")
  mock_readline_fail <- mockery::mock("3", oversized_number, "abc", cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_fail)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(new_item_1 = c(1, 0, 1)),
      oldformYData = data.frame(old_item_1 = c(0, 1, 0)),
      newformCommonItemNames = c("new_item_1"),
      oldformCommonItemNames = c("old_item_1"),
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("old-form BILOG prompt accepts only 1 or 2", {
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  oversized_number <- paste(rep("9", 1000), collapse = "")
  mock_readline_fail <- mockery::mock("3", oversized_number, "abc", cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_fail)

  test_data <- data.frame(
    item1 = rep(c(0, 1), 50),
    item2 = rep(c(1, 0), 50),
    item3 = rep(c(0, 0, 1, 1), 25)
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = test_data,
      oldformYData = test_data,
      newformCommonItemNames = c("item1", "item2"),
      oldformCommonItemNames = c("item1", "item2"),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      oldformBILOGprior = NULL
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("new-form BILOG prompt accepts only 1 or 2", {
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  oversized_number <- paste(rep("9", 1000), collapse = "")
  mock_readline_fail <- mockery::mock("1", "3", oversized_number, "abc", cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline_fail)

  setClass("mockMirtClass", representation(OptimInfo = "list", Data = "list"))
  mockObj <- new(
    "mockMirtClass",
    OptimInfo = list(secondordertest = TRUE),
    Data = list(K = c(2, 2))
  )

  mockery::stub(aFIPC::autoFIPC, "mirt::mirt", function(...) mockObj)
  mockery::stub(aFIPC::autoFIPC, "mirt::extract.mirt", function(...) list())
  mockery::stub(aFIPC::autoFIPC, "mirt::multipleGroup", function(...) list())
  mockery::stub(aFIPC::autoFIPC, "aFIPC::make_aFIPC_model", function(...) list())

  test_data <- data.frame(
    item1 = c(1, 0, 1, 0, 1),
    item2 = c(0, 1, 0, 1, 0)
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = test_data,
      oldformYData = test_data,
      newformCommonItemNames = c("item1"),
      oldformCommonItemNames = c("old_item_1"),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      oldformBILOGprior = NULL,
      newformBILOGprior = NULL
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
