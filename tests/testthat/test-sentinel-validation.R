test_that("autoFIPC validates boolean flags for newformBILOGprior, oldformBILOGprior, and confirmCommonItems", {
  # newformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      newformBILOGprior = "TRUE"
    ),
    "Security Error: newformBILOGprior must be a single non-NA logical value or NULL"
  )

  # oldformBILOGprior
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      oldformBILOGprior = c(TRUE, FALSE)
    ),
    "Security Error: oldformBILOGprior must be a single non-NA logical value or NULL"
  )

  # confirmCommonItems
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A'),
      confirmCommonItems = NA
    ),
    "Security Error: confirmCommonItems must be a single non-NA logical value or NULL"
  )
})


test_that("binary menu choice accepts only exact documented values", {
  make_reader <- function(values) {
    force(values)
    function(prompt) {
      value <- values[[1]]
      values <<- values[-1]
      value
    }
  }

  expect_identical(
    aFIPC:::.read_binary_choice("prompt", "invalid", make_reader("1")),
    1L
  )
  expect_identical(
    aFIPC:::.read_binary_choice("prompt", "invalid", make_reader("2")),
    2L
  )
  expect_identical(
    aFIPC:::.read_binary_choice(
      "prompt",
      "invalid",
      make_reader(c("0", "3", "1"))
    ),
    1L
  )
  expect_error(
    aFIPC:::.read_binary_choice(
      "prompt",
      "invalid",
      make_reader(c("12", "2147483648", " 1"))
    ),
    "invalid",
    fixed = TRUE
  )

  for (value in c("3", "10", "2147483648", "invalid", "")) {
    expect_error(
      aFIPC:::.read_binary_choice(
        "prompt",
        "invalid",
        make_reader(rep(value, 3))
      ),
      "invalid",
      fixed = TRUE,
      info = paste("unexpectedly accepted binary menu value", dQuote(value))
    )
  }
})
