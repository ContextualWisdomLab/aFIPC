test_that("autoFIPC raises error in non-interactive session for inputs", {
  # interactive() should be FALSE by default in testthat environments
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Common item confirmation requires an interactive session"
  )
})

test_that("autoFIPC does not implicitly approve supplied common items", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = FALSE
    ),
    "Please write down pairs correctly"
  )
})

test_that("autoFIPC validates input types securely", {
  expect_error(
    aFIPC::autoFIPC(
      newformXData = 1,
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Security Error: newformXData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = 123,
      oldformCommonItemNames = c('A')
    ),
    "Security Error: newformCommonItemNames must be a character vector"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      itemtype = c("3PL", "2PL")
    ),
    "Security Error: itemtype must be length 1 or length 1 \\(number of items\\)."
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = structure(list(), class = "SingleGroupClass"),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = TRUE
    ),
    "Security Error: oldformYData must be a data.frame, matrix, or a valid fitted mirt model"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryFitwholeNewItems = "TRUE"
    ),
    "Security Error: tryFitwholeNewItems must be a single non-NA logical value"
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      tryEM = NA
    ),
    "Security Error: tryEM must be a single non-NA logical value"
  )
})

test_that("autoFIPC common-item category count preserves NA semantics without na.omit", {
  source_text <- paste(deparse(body(aFIPC::autoFIPC)), collapse = "\n")

  expect_match(source_text, "sum(!is.na(unique(newFormModel@Data$data[, newFormItemName])))", fixed = TRUE)
  expect_match(source_text, "sum(!is.na(unique(oldFormModel@Data$data[, oldFormItemName])))", fixed = TRUE)
  expect_false(grepl("stats::na.omit(unique(newFormModel@Data$data", source_text, fixed = TRUE))
  expect_false(grepl("stats::na.omit(unique(oldFormModel@Data$data", source_text, fixed = TRUE))

  representative <- list(
    c(1, 1, NA),
    c(1, 2, NA, 2),
    c(NA, NA),
    c("A", "B", NA, "A")
  )
  for (values in representative) {
    legacy_count <- length(stats::na.omit(unique(values)))
    direct_count <- sum(!is.na(unique(values)))
    expect_identical(direct_count, legacy_count)
  }
})
