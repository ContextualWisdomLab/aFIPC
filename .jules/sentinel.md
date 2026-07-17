## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-28 - Integer coercion vulnerabilities with unvalidated `readline()` outputs
**Vulnerability:** Interactive prompts taking user input (like `readline()`) without strict length or value limits can be bypassed with excessively large numbers (e.g. `"999999999999999999"`). If only checked with a generic numeric regex `^[0-9]+$`, `as.integer()` will coerce them to `NA`, causing an unhandled `NAs introduced by coercion to integer range` condition that crashes the application process on downstream evaluations.
**Learning:** `as.integer()` evaluates to `NA` when given values exceeding integer bounds, even if the value string contains only digits.
**Prevention:** Strictly validate `readline()` numeric inputs against exact expected values (e.g., `^[12]$`) instead of unbounded digits (`^[0-9]+$`) to prevent overflow coercion to `NA` and DoS risk.
