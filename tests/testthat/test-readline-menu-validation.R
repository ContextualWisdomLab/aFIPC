make_bilog_prompt_fixture <- function() {
  set.seed(42)
  new_data <- as.data.frame(matrix(sample(0:1, 100 * 20, replace = TRUE), ncol = 20))
  old_data <- as.data.frame(matrix(sample(0:1, 100 * 20, replace = TRUE), ncol = 20))
  colnames(new_data) <- paste0("Item", seq_len(20))
  colnames(old_data) <- paste0("Item", seq_len(20))

  old_model <- mirt::mirt(old_data, 1, itemtype = "Rasch", verbose = FALSE, TOL = 1000)
  new_model <- mirt::mirt(new_data, 1, itemtype = "Rasch", verbose = FALSE, TOL = 1000)
  old_model@Model$itemtype <- rep("3PL", 20)
  new_model@Model$itemtype <- rep("3PL", 20)

  list(new_model = new_model, old_model = old_model)
}

test_that("old-form BILOG prompt rejects integers outside the menu domain", {
  fixture <- make_bilog_prompt_fixture()
  mockery::stub(autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(autoFIPC, "interactive", TRUE)

  expect_error(
    autoFIPC(
      newformXData = fixture$new_model,
      oldformYData = fixture$old_model,
      newformCommonItemNames = paste0("Item", seq_len(20)),
      oldformCommonItemNames = paste0("Item", seq_len(20)),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      tryFitwholeOldItems = FALSE,
      tryFitwholeNewItems = FALSE
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("new-form BILOG prompt rejects integers outside the menu domain", {
  fixture <- make_bilog_prompt_fixture()
  mockery::stub(autoFIPC, "readline", "999999999999999999999999999999")
  mockery::stub(autoFIPC, "interactive", TRUE)

  expect_error(
    autoFIPC(
      newformXData = fixture$new_model,
      oldformYData = fixture$old_model,
      newformCommonItemNames = paste0("Item", seq_len(20)),
      oldformCommonItemNames = paste0("Item", seq_len(20)),
      confirmCommonItems = TRUE,
      itemtype = "3PL",
      oldformBILOGprior = TRUE,
      tryFitwholeOldItems = FALSE,
      tryFitwholeNewItems = FALSE
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
