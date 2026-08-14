test_that("R CMD check uses an active reviewed dependency cache generation", {
  workflow_path <- testthat::test_path(
    "..", "..", ".github", "workflows", "r.yml"
  )
  workflow_lines <- readLines(workflow_path, warn = FALSE)
  dependency_step <- grep(
    "r-lib/actions/setup-r-dependencies@",
    workflow_lines,
    fixed = TRUE
  )
  expect_length(dependency_step, 1L)
  dependency_block <- workflow_lines[
    dependency_step:min(dependency_step + 8L, length(workflow_lines))
  ]
  active_cache_version_pattern <- paste0(
    "^[[:space:]]*cache-version:[[:space:]]*",
    "['\\\"]2['\\\"][[:space:]]*(#.*)?$"
  )

  expect_false(
    grepl(active_cache_version_pattern, "# cache-version: '2'", perl = TRUE)
  )
  expect_true(
    any(grepl(active_cache_version_pattern, dependency_block, perl = TRUE)),
    info = "The TBB ABI cache refresh must remain an active workflow input"
  )
})
