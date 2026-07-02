#!/usr/bin/env Rscript

script_args <- commandArgs(trailingOnly = FALSE)
file_arg <- script_args[grepl("^--file=", script_args)]
script_file <- if (length(file_arg) > 0L) {
  sub("^--file=", "", file_arg[[1L]])
} else {
  file.path("scripts", "validate-sale-readiness.R")
}

repo_root <- normalizePath(file.path(dirname(script_file), ".."), mustWork = TRUE)
setwd(repo_root)
Sys.setenv(R_PROFILE_USER = "/dev/null")

strip_ansi <- function(output) {
  gsub("\033\\[[0-9;]*[[:alpha:]]", "", output)
}

run_rscript_gate <- function(label, expression) {
  message("\n==> ", label)
  rscript <- file.path(R.home("bin"), "Rscript")
  gate_file <- tempfile(pattern = "afipc-sale-readiness-", fileext = ".R")
  writeLines(expression, gate_file)
  on.exit(unlink(gate_file), add = TRUE)
  output <- suppressWarnings(system2(
    rscript,
    c("--vanilla", gate_file),
    stdout = TRUE,
    stderr = TRUE,
    env = c("R_PROFILE_USER=/dev/null")
  ))
  status <- attr(output, "status")
  if (is.null(status)) {
    status <- 0L
  }

  if (length(output) > 0L) {
    cat(output, sep = "\n")
    cat("\n")
  }

  list(status = status, output = strip_ansi(output))
}

require_tool_expression <- function(package_name, install_hint = package_name) {
  paste0(
    "if (!requireNamespace('", package_name, "', quietly = TRUE)) ",
    "stop('Required validation package missing: ", package_name,
    ". Install with install.packages(\"", install_hint, "\").', call. = FALSE); "
  )
}

test_expr <- paste0(
  require_tool_expression("pkgload"),
  require_tool_expression("testthat"),
  "pkgload::load_all(); ",
  "testthat::test_dir('tests/testthat')"
)

check_expr <- paste0(
  require_tool_expression("rcmdcheck"),
  "rcmdcheck::rcmdcheck(",
  "args = c('--no-manual', '--as-cran'), ",
  "error_on = 'warning'",
  ")"
)

test_gate <- run_rscript_gate("testthat sale-readiness gate", test_expr)
test_output <- paste(test_gate$output, collapse = "\n")
test_summary_ok <- grepl(
  "\\[ FAIL 0 \\| WARN 0 \\| SKIP 0 \\| PASS [0-9]+ \\]",
  test_output
)

if (test_gate$status != 0L || !test_summary_ok) {
  stop(
    "testthat sale-readiness gate failed. Required summary: ",
    "[ FAIL 0 | WARN 0 | SKIP 0 | PASS <n> ].",
    call. = FALSE
  )
}

check_gate <- run_rscript_gate("R CMD check sale-readiness gate", check_expr)
check_output <- paste(check_gate$output, collapse = "\n")
check_summary_ok <- grepl("0 errors.*0 warnings", check_output)

if (check_gate$status != 0L || !check_summary_ok) {
  stop(
    "R CMD check sale-readiness gate failed. Required summary: ",
    "0 errors and 0 warnings. CRAN new-submission NOTE is documented as ",
    "non-blocking.",
    call. = FALSE
  )
}

message("\nSALE_READINESS_OK")
message("Required gates passed: testthat FAIL 0/WARN 0/SKIP 0 and R CMD check 0 errors/0 warnings.")
