test_that("regex validation properly restricts to exactly 1 or 2", {
  my_readline <- function(...) { "12" }
  my_interactive <- function() TRUE
  mockery::stub(aFIPC::autoFIPC, 'interactive', my_interactive)
  mockery::stub(aFIPC::autoFIPC, 'readline', my_readline)
  new_model <- data.frame(item1 = c(1, 0), item2 = c(0, 1))
  old_model <- data.frame(item1 = c(1, 0), item2 = c(0, 1))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = c('item1'),
      oldformCommonItemNames = c('item1')
    ), "Too many invalid common item confirmation attempts")
})

test_that("regex validation properly restricts to exactly 1 or 2 for oldformBILOGprior", {
  my_readline <- function(...) { "12" }
  my_interactive <- function() TRUE
  mockery::stub(aFIPC::autoFIPC, 'interactive', my_interactive)
  mockery::stub(aFIPC::autoFIPC, 'readline', my_readline)
  new_model <- data.frame(item1 = c(1, 0, 1, 0, 1), item2 = c(0, 1, 0, 1, 0))
  old_model <- data.frame(item1 = c(1, 0, 1, 0, 1), item2 = c(0, 1, 0, 1, 0))

  expect_error(
    aFIPC::autoFIPC(
      newformXData = new_model,
      oldformYData = old_model,
      newformCommonItemNames = c('item1'),
      oldformCommonItemNames = c('item1'),
      confirmCommonItems = TRUE,
      itemtype = '3PL',
      tryFitwholeOldItems = TRUE
    ), "Too many invalid oldform BILOG prior attempts")
})
