#' @title surveyFA
#' @description Placeholder for the surveyFA fallback path.
#' @param ... Arguments passed to the function
#' @return This function currently errors because the historical fallback
#'   algorithm is not implemented in this package.
#' @importFrom stats factanal
#' @export
surveyFA <- function(...) {
  stop(
    "surveyFA fallback is not implemented in this package; ",
    "use direct mirt model inputs or add a maintainer-approved fallback ",
    "implementation with regression fixtures.",
    call. = FALSE
  )
}
