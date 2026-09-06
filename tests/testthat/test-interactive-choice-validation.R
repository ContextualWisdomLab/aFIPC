test_that("common-item confirmation rejects values outside 1 or 2", {
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  mock_readline <- mockery::mock("0", "3", "12", cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(new_item_1 = c(1, 0, 1)),
      oldformYData = data.frame(old_item_1 = c(0, 1, 0)),
      newformCommonItemNames = "new_item_1",
      oldformCommonItemNames = "old_item_1",
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("old-form prior prompt rejects malformed and out-of-range choices", {
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  oversized_integer <- paste(rep("9", 1000), collapse = "")
  mock_readline <- mockery::mock(" 1", "abc", oversized_integer, cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline)

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

test_that("new-form prior prompt rejects malformed and out-of-range choices", {
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  oversized_integer <- paste(rep("9", 1000), collapse = "")
  mock_readline <- mockery::mock("1", "3", "abc", oversized_integer, cycle = TRUE)
  mockery::stub(aFIPC::autoFIPC, "readline", mock_readline)

  # autoFIPC reads these mirt slots directly before reaching the new-form prompt.
  fake_model <- new("SingleGroupClass")
  fake_model@OptimInfo <- list(secondordertest = TRUE)
  fake_model@Data <- list(K = c(2, 2))

  mockery::stub(aFIPC::autoFIPC, "mirt::mirt", fake_model)
  mockery::stub(aFIPC::autoFIPC, "mirt::multipleGroup", fake_model)
  mockery::stub(aFIPC::autoFIPC, "aFIPC:::make_aFIPC_model", fake_model)

  test_data <- data.frame(
    item1 = c(1, 0, 1, 0, 1),
    item2 = c(0, 1, 0, 1, 0)
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = test_data,
      oldformYData = test_data,
      newformCommonItemNames = "item1",
      oldformCommonItemNames = "item1",
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      oldformBILOGprior = NULL,
      newformBILOGprior = NULL
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
