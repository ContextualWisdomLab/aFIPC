## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-25 - [Integer Overflow Coercion Vulnerability]
**Vulnerability:** Unbounded regex `^[0-9]+$` on interactive `readline()` prompt allowed excessively large digit inputs which evaluate to `NA` inside `as.integer()`, leading to subsequent process crashes or unexpected state in automated/headless setups.
**Learning:** Even simple boolean/menu choice prompts ("1: Yes 2: No") are susceptible to overflow/type vulnerabilities if validated loosely. Coercing unbounded input via `as.integer()` fails silently to `NA`.
**Prevention:** Strictly limit regex matches to expected choice domains (e.g., `^[12]$`) instead of generic digit classes when prompting for specific integer flags.
