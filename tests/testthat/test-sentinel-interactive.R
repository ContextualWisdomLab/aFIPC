test_that("interactive prompt integer overflows are prevented", {
  library(mockery)

  df_new <- data.frame(A=c(0,1), B=c(1,0))
  df_old <- df_new

  mock_mirt <- function(...) {
    # We must use S4 class mock
    res <- new("SingleGroupClass")
    res@OptimInfo <- list(secondordertest = TRUE)
    res@Fit <- list(logLik = 0)
    res@Data <- list(data = data.frame(A=1, B=2))
    # We also need these for later or stub mod2values
    return(res)
  }

  stub(aFIPC::autoFIPC, "mirt::mirt", mock_mirt)

  # mock mod2values to return something basic so it doesn't crash if it gets that far
  stub(aFIPC::autoFIPC, "mirt::mod2values", function(...) data.frame(item="A", name="a1", est=TRUE, value=1))
  stub(aFIPC::autoFIPC, "isRealMirtModel", function(...) TRUE)

  # 1. confirmCommonItems
  mock_readline_confirm <- mock("3", "9999999999999999999999", "a")
  mock_interactive <- mock(TRUE, cycle=TRUE)

  stub(aFIPC::autoFIPC, "readline", mock_readline_confirm)
  stub(aFIPC::autoFIPC, "interactive", mock_interactive)

  suppressMessages(suppressWarnings(
    expect_error(
      aFIPC::autoFIPC(
        newformXData = mock_mirt(),
        oldformYData = mock_mirt(),
        newformCommonItemNames = c('A', 'B'),
        oldformCommonItemNames = c('A', 'B'),
        itemtype = 'Rasch',
        tryFitwholeNewItems = FALSE,
        tryFitwholeOldItems = FALSE,
        confirmCommonItems = NULL # Should trigger interactive prompt
      ),
      "Too many invalid common item confirmation attempts"
    )
  ))

  # 2. oldformBILOGprior
  mock_readline_oldform <- mock("9999999999999999999999", "3", "a")
  stub(aFIPC::autoFIPC, "readline", mock_readline_oldform)

  suppressMessages(suppressWarnings(
    expect_error(
      aFIPC::autoFIPC(
        newformXData = df_new,
        oldformYData = df_old,
        newformCommonItemNames = c('A', 'B'),
        oldformCommonItemNames = c('A', 'B'),
        itemtype = '3PL',
        confirmCommonItems = TRUE,
        newformBILOGprior = TRUE,
        oldformBILOGprior = NULL, # Should trigger interactive prompt
        tryFitwholeNewItems = FALSE,
        tryFitwholeOldItems = FALSE
      ),
      "Too many invalid oldform BILOG prior attempts"
    )
  ))

  # 3. newformBILOGprior
  mock_readline_newform <- mock("9999999999999999999999", "3", "a")
  stub(aFIPC::autoFIPC, "readline", mock_readline_newform)

  suppressMessages(suppressWarnings(
    expect_error(
      aFIPC::autoFIPC(
        newformXData = df_new,
        oldformYData = df_old,
        newformCommonItemNames = c('A', 'B'),
        oldformCommonItemNames = c('A', 'B'),
        itemtype = '3PL',
        confirmCommonItems = TRUE,
        newformBILOGprior = NULL, # Should trigger interactive prompt
        oldformBILOGprior = TRUE,
        tryFitwholeNewItems = FALSE,
        tryFitwholeOldItems = FALSE
      ),
      "Too many invalid newform BILOG prior attempts"
    )
  ))
})
