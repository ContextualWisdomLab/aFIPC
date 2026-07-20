test_that("binary prompt choices accept only the documented scalar inputs", {
  expect_true(aFIPC:::.is_binary_prompt_choice("1"))
  expect_true(aFIPC:::.is_binary_prompt_choice("2"))

  invalid <- list(
    "0",
    "3",
    "01",
    "1 ",
    " 2",
    "999999999999999999999999999999999999999999",
    "not-a-number",
    NA_character_,
    character(),
    c("1", "2"),
    1L
  )

  for (value in invalid) {
    expect_false(aFIPC:::.is_binary_prompt_choice(value))
  }
})
