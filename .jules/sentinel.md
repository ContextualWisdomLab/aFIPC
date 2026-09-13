## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2026-09-08 - Integer Coercion Vulnerability in Interactive Prompts
**Vulnerability:** Weak regex `^[0-9]+$` for `readline()` validation allowed arbitrarily large numbers, which coerced to `NA` when converted to 32-bit integers via `as.integer()`.
**Learning:** In R, integers have a strict 32-bit limit. Allowing unbounded numeric input for menu selections creates an input validation bypass that crashes downstream logic.
**Prevention:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) for menu selections instead of generic numeric matching.
