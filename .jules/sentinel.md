## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-06 - Fix integer overflow coercion vulnerability in interactive inputs
**Vulnerability:** Integer overflow coercion vulnerability where excessively large numeric strings pass unbounded regex checks (e.g., `^[0-9]+$`) but evaluate to `NA` in `as.integer()`, causing subsequent process crashes.
**Learning:** In R scripts, when validating interactive `readline()` numeric inputs, unbounded digit classes (e.g., `^[0-9]+$`) can lead to unexpected `NA` coercion for extremely large numbers, leading to unhandled downstream exceptions.
**Prevention:** Strictly match interactive numeric inputs against exact expected values (e.g., `^[12]$`) rather than unbounded digit classes.
