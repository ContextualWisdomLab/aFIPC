test_that("binary prompt choice parser accepts only exact 1 or 2", {
  expect_identical(aFIPC:::.parse_binary_prompt_choice("1"), 1L)
  expect_identical(aFIPC:::.parse_binary_prompt_choice("2"), 2L)

  invalid <- c(
    "",
    "0",
    "3",
    "01",
    "12",
    " 1",
    "1 ",
    "999999999999999999999999999999999999999999999999999999"
  )

  for (value in invalid) {
    expect_null(aFIPC:::.parse_binary_prompt_choice(value), info = value)
  }
})
