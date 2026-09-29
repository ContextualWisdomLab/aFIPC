#' Internal helper to prompt user for yes/no confirmation interactively
#' @param message the string to prompt the user
#' @param .readline testing seam for readline
#' @param .interactive testing seam for interactive
#' @return an integer 1 or 2
promptUserConfirm <- function(message, .readline = readline, .interactive = interactive) {
  if (!.interactive()) {
    stop("Confirmation requires an interactive session.")
  }
  for (attempt in seq_len(3)) {
    n <- .readline(prompt = message)
    if (n %in% c("1", "2")) {
      return(as.integer(n))
    }
  }
  stop("Too many invalid attempts")
}
