## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-30 - Fix weak regex validation in readline prompts
**Vulnerability:** Interactive `readline` prompts in `R/aFIPC.R` previously validated integer inputs using the weak regex `^[0-9]+$`. This allows arbitrarily large numbers which, when cast via `as.integer()`, cause integer overflow and coerce to `NA`, leading to unhandled condition lengths and process crashes.
**Learning:** Broad regex limits in interactive R prompts are insecure and can easily cause DoS via unexpected data coercion.
**Prevention:** Always use strictly bounded exact-match regex like `^[12]$` when validating integer inputs expected to match small, specific sets of choices.
