make_interactive_auto_fipc <- function(responses) {
  prompt_count <- 0L
  subject <- autoFIPC
  overrides <- new.env(parent = environment(subject))
  overrides$interactive <- function() TRUE
  overrides$readline <- function(prompt = "") {
    prompt_count <<- prompt_count + 1L
    responses[[prompt_count]]
  }
  environment(subject) <- overrides

  list(
    run = function() {
      subject(
        newformXData = matrix(c(0, 1), ncol = 1),
        oldformYData = matrix(c(0, 1), ncol = 1),
        newformCommonItemNames = "item1",
        oldformCommonItemNames = "item1",
        itemtype = "2PL"
      )
    },
    prompt_count = function() prompt_count
  )
}

test_that("autoFIPC rejects non-menu numeric input before integer coercion", {
  harness <- make_interactive_auto_fipc(c("3", "99999999999999999999", "10"))

  expect_error(
    harness$run(),
    "Too many invalid common item confirmation attempts",
    fixed = TRUE
  )
  expect_equal(harness$prompt_count(), 3L)
})

test_that("autoFIPC accepts the exact menu choice 2", {
  harness <- make_interactive_auto_fipc("2")

  expect_error(
    harness$run(),
    "Please write down pairs correctly",
    fixed = TRUE
  )
  expect_equal(harness$prompt_count(), 1L)
})
