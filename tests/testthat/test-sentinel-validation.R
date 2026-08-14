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

test_that("interactive readline input bounded regex validation prevents DoS", {
  mockery::stub(aFIPC::autoFIPC, 'interactive', TRUE)
  my_readline <- function(...) '99999999999999999999'
  mockery::stub(aFIPC::autoFIPC, 'readline', my_readline)

  # This should error out from 'Too many invalid common item confirmation attempts'
  # instead of failing due to NA coercion in if condition
  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A=1),
      oldformYData = data.frame(A=2),
      newformCommonItemNames = c('A'),
      oldformCommonItemNames = c('A')
    ),
    "Too many invalid common item confirmation attempts"
  )
})


test_that("oldform BILOG prompt rejects repeated overlong integer input", {
  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  calls <- new.env(parent = emptyenv())
  calls$count <- 0L
  overlong_readline <- function(...) {
    calls$count <- calls$count + 1L
    "99999999999999999999"
  }
  mockery::stub(aFIPC::autoFIPC, "readline", overlong_readline)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = data.frame(A = 1),
      oldformYData = data.frame(A = 2),
      newformCommonItemNames = "A",
      oldformCommonItemNames = "A",
      newformBILOGprior = FALSE,
      confirmCommonItems = TRUE
    ),
    "Too many invalid oldform BILOG prior attempts"
  )
  expect_equal(calls$count, 3L)
})

test_that("newform BILOG prompt rejects repeated overlong integer input", {
  skip_if_not_installed("mirt")
  set.seed(20260815)
  old_data <- as.data.frame(mirt::simdata(
    a = matrix(rep(1, 4), ncol = 1),
    d = c(-1, -0.3, 0.3, 1),
    itemtype = rep("2PL", 4),
    N = 200
  ))
  names(old_data) <- LETTERS[1:4]
  old_model <- mirt::mirt(
    old_data,
    1,
    itemtype = "2PL",
    SE = FALSE,
    verbose = FALSE
  )

  mockery::stub(aFIPC::autoFIPC, "interactive", TRUE)
  calls <- new.env(parent = emptyenv())
  calls$count <- 0L
  overlong_readline <- function(...) {
    calls$count <- calls$count + 1L
    "99999999999999999999"
  }
  mockery::stub(aFIPC::autoFIPC, "readline", overlong_readline)

  expect_error(
    aFIPC::autoFIPC(
      newformXData = old_data,
      oldformYData = old_model,
      newformCommonItemNames = "A",
      oldformCommonItemNames = "A",
      itemtype = "3PL",
      oldformBILOGprior = FALSE,
      confirmCommonItems = TRUE,
      checkIPD = FALSE
    ),
    "Too many invalid newform BILOG prior attempts"
  )
  expect_equal(calls$count, 3L)
})
