.parse_binary_choice <- function(value) {
  if (
    !is.character(value) ||
      length(value) != 1L ||
      is.na(value) ||
      !(value %in% c("1", "2"))
  ) {
    return(NA_integer_)
  }

  as.integer(value)
}
