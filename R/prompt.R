get_confirmation <- function(prompt_msg, .readline = readline, .interactive = interactive) {
  if (!.interactive()) stop("Interactive session required for prompt")
  for (attempt in seq_len(3)) {
    n <- .readline(prompt = prompt_msg)
    if (n %in% c("1", "2")) {
      return(as.integer(n))
    }
  }
  stop("Too many invalid attempts")
}
