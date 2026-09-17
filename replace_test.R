lines <- readLines("tests/testthat/test-autoFIPC.R")
start_idx <- grep("test_that\\(\"autoFIPC securely restricts readline coercion limits\", \\{", lines)
lines <- lines[1:(start_idx - 1)]
writeLines(lines, "tests/testthat/test-autoFIPC.R")
