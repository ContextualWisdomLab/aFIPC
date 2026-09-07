prompt_fixture <- function() {
  list(
    new = data.frame(item1 = c(1, 0, 1), item2 = c(0, 1, 0)),
    old = data.frame(item1 = c(1, 0, 1), item2 = c(0, 1, 0))
  )
}

successful_single_group <- function(data) {
  mod <- methods::new("SingleGroupClass")
  mod@OptimInfo$converged <- TRUE
  mod@OptimInfo$secondordertest <- TRUE
  mod@Data$data <- data
  mod
}

test_that("common-item confirmation rejects non-binary choices before coercion", {
  fixture <- prompt_fixture()

  mockery::stub(aFIPC::autoFIPC, "mirt::mirt", function(data, ...) {
    successful_single_group(data)
  })
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  mockery::stub(
    aFIPC::autoFIPC,
    "readline",
    mockery::mock("3", "999999999999", "0", "1")
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = fixture$new,
      oldformYData = fixture$old,
      newformCommonItemNames = "item1",
      oldformCommonItemNames = "item1",
      confirmCommonItems = NULL
    ),
    "Too many invalid common item confirmation attempts"
  )
})

test_that("both BILOG prior prompts retry invalid values and admit exact binary choices", {
  fixture <- prompt_fixture()
  readline_values <- c("3", "999999999999", "2", "0", "999999999999", "1")
  readline_index <- 0L

  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  mockery::stub(aFIPC::autoFIPC, "mirt::mirt.model", function(...) 1)
  mockery::stub(aFIPC::autoFIPC, "mirt::mirt", function(data, ...) {
    successful_single_group(data)
  })
  mockery::stub(aFIPC::autoFIPC, "readline", function(...) {
    readline_index <<- readline_index + 1L
    readline_values[[readline_index]]
  })

  invisible(try(
    aFIPC::autoFIPC(
      newformXData = fixture$new,
      oldformYData = fixture$old,
      newformCommonItemNames = "item1",
      oldformCommonItemNames = "item1",
      confirmCommonItems = TRUE,
      oldformBILOGprior = NULL,
      newformBILOGprior = NULL
    ),
    silent = TRUE
  ))

  expect_equal(readline_index, 6L)
})

test_that("oldform BILOG prior prompt fails after three invalid choices", {
  fixture <- prompt_fixture()

  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  mockery::stub(
    aFIPC::autoFIPC,
    "readline",
    mockery::mock("3", "999999999999", "0")
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = fixture$new,
      oldformYData = fixture$old,
      newformCommonItemNames = "item1",
      oldformCommonItemNames = "item1",
      confirmCommonItems = TRUE,
      oldformBILOGprior = NULL,
      newformBILOGprior = FALSE
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
})

test_that("newform BILOG prior prompt fails after three invalid choices", {
  fixture <- prompt_fixture()

  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  mockery::stub(aFIPC::autoFIPC, "mirt::mirt", function(data, ...) {
    successful_single_group(data)
  })
  mockery::stub(
    aFIPC::autoFIPC,
    "readline",
    mockery::mock("3", "999999999999", "0")
  )

  expect_error(
    aFIPC::autoFIPC(
      newformXData = fixture$new,
      oldformYData = fixture$old,
      newformCommonItemNames = "item1",
      oldformCommonItemNames = "item1",
      confirmCommonItems = TRUE,
      oldformBILOGprior = FALSE,
      newformBILOGprior = NULL
    ),
    "Too many invalid newform BILOG prior attempts"
  )
})
