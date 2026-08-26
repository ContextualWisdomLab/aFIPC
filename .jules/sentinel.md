## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-21 - Fix input coercion vulnerability in interactive prompts
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline()` prompts allows large number inputs which coerce to `NA` and crash downstream boolean conditionals.
**Learning:** In R, `as.integer()` will coerce excessively large strings to `NA` with a warning, violating expectations of bounded numerical validation.
**Prevention:** Always use bounded, exact-match regex like `^[12]$` when validating constrained integer choices from user input.
