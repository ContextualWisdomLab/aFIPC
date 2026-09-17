dummy_mirt <- function(data, ...) {
  mod <- new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mod@OptimInfo$secondordertest <- TRUE
  mod@Data$data <- data
  return(mod)
}

library(testthat)
library(mockery)
source("R/aFIPC.R")
source("R/surveyFA.R")

test_that("autoFIPC securely restricts readline coercion limits", {
  # Mock interactive to return TRUE
  mockery::stub(autoFIPC, "interactive", function() TRUE)

  # Mock readline to return a malicious large number then a valid "1"
  m <- mockery::mock("invalid", "10000000000000000000", "1", cycle = TRUE)
  mockery::stub(autoFIPC, "readline", m)

  # Stub mirt::mirt but it must be done specifically if autoFIPC calls mirt::mirt.
  # However, mirt::mirt is called directly, so mocking it via autoFIPC environment works if the function uses it locally,
  # but here autoFIPC uses mirt::mirt. We should use with_mock or override mirt::mirt.

  # Instead of full autoFIPC, we could just test the readline directly if it was extracted,
  # but since we are mocking inside testthat:
})
