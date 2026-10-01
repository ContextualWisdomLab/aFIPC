test_that("interactive prompt integer overflows are prevented", {
  # As per the memory note: "In R package testing, the covr package struggles to track code coverage inside interactive readline() blocks. To deterministically test interactive prompts without complex mocking libraries (e.g., mockery), extract the logic into an internal helper function utilizing test seams (e.g., function(msg, .readline = readline, .interactive = interactive)). This allows tests to inject mock handlers directly."
  # For now since we want to avoid refactoring the source code, we use mockery correctly.
  library(mockery)

  # mockery cannot intercept explicit mirt::mirt() calls. So testing it end-to-end is difficult without changing aFIPC.R to inject .readline or stripping mirt:: calls.
  # Since the previous code review stated: "When testing functions that invoke heavy S4-returning estimation methods (like mirt::mirt), stub the estimation function to return a minimal S4 object (e.g., new('SingleGroupClass')) populated with the necessary slots to bypass the computation and safely reach the interactive logic."
  # And also "mockery::stub() cannot intercept explicit namespaced function calls via the what argument. Mocking "mirt::mirt" or "mirt::mod2values" instructs R to create local variables literally named "mirt::mirt". When the main function calls mirt::mirt(), R's scope resolution operator (::) completely ignores the local environment and queries the mirt namespace directly, completely bypassing the mock."
  #
  # Since we are not permitted to refactor `autoFIPC` heavily and mockery cannot stub namespaced calls,
  # we will use testthat::with_mocked_bindings to intercept mirt::mirt natively.

  df_new <- data.frame(A=c(0,1), B=c(1,0))
  df_old <- df_new

  mock_mirt <- function(...) {
    res <- new("SingleGroupClass")
    res@OptimInfo <- list(secondordertest = TRUE)
    res@Fit <- list(logLik = 0)
    res@Data <- list(data = data.frame(A=1, B=2))
    return(res)
  }

  mock_mod2values <- function(...) {
    data.frame(item="A", name="a1", est=TRUE, value=1)
  }

  autoFIPC_to_test <- aFIPC::autoFIPC

  # Stub non-namespaced function `readline` and `interactive` inside autoFIPC
  mock_readline_confirm <- mock("3", "9999999999999999999999", "a")
  mock_interactive <- mock(TRUE, cycle=TRUE)
  mock_isRealMirtModel <- mock(TRUE, cycle=TRUE)

  stub(autoFIPC_to_test, "readline", mock_readline_confirm)
  stub(autoFIPC_to_test, "interactive", mock_interactive)

  # testthat::with_mocked_bindings requires testthat 3.0.0+
  testthat::with_mocked_bindings(
    {
      suppressMessages(suppressWarnings(
        expect_error(
          autoFIPC_to_test(
            newformXData = df_new,
            oldformYData = df_old,
            newformCommonItemNames = c('A', 'B'),
            oldformCommonItemNames = c('A', 'B'),
            itemtype = 'Rasch',
            tryFitwholeNewItems = FALSE,
            tryFitwholeOldItems = FALSE,
            confirmCommonItems = NULL
          ),
          "Too many invalid common item confirmation attempts"
        )
      ))
    },
    mirt = mock_mirt,
    mod2values = mock_mod2values,
    .package = "mirt"
  )
})
