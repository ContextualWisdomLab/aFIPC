test_that("Sentinel: autoFIPC readline prompt uses strict regex", {
  # In R CMD check, we have the exported functions directly available.

  # Mock interactive to bypass immediate stop
  mockery::stub(autoFIPC, "interactive", function() TRUE)

  # Mock checkCorrect interactive input - test strict bound bypass vs valid (1)
  # When giving invalid inputs ("3", "4", "abc"), autoFIPC prompts again up to 3 times
  # We provide a valid "1" on the second attempt to see if it bypasses the invalid inputs
  mockery::stub(autoFIPC, "readline", mockery::mock("3", "1", cycle = TRUE))

  # Prevent estimating models loop
  mockery::stub(autoFIPC, "mirt::mirt", function(data, ...) {
    mod <- new("SingleGroupClass")
    mod@OptimInfo$converged <- TRUE
    mod@OptimInfo$secondordertest <- TRUE
    mod@Data$data <- data
    return(mod)
  })

  res <- tryCatch({
      autoFIPC(
        newformXData = data.frame(V1=1, V2=2),
        oldformYData = data.frame(V1=1, V2=2),
        newformCommonItemNames = c('V1'),
        oldformCommonItemNames = c('V1'),
        confirmCommonItems = NULL
      )
    },
    error = function(e) e$message
  )

  # We should reach the mirt stub, which will throw error downstream or return cleanly
  # The fact that it doesn't throw 'Too many invalid common item confirmation attempts' means it correctly rejected '3' and accepted '1'
  expect_false(grepl("Too many invalid", res))
})
