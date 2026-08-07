## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-23 - Strict Numeric Input Validation for `readline()`
**Vulnerability:** In R scripts, validating interactive `readline()` numeric inputs against unbounded digit classes (e.g., `^[0-9]+$`) rather than strict exact expected values (e.g., `^[12]$`) can cause integer overflow coercion vulnerabilities. Excessively large numeric strings will pass the regex check but evaluate to `NA` when coerced with `as.integer()`, causing downstream crashes or unexpected state.
**Learning:** Bounded inputs must be strictly validated for the specific range expected rather than broadly accepting any number of digits, as unbounded strings bypass size limitations.
**Prevention:** Always implement strict matching (e.g., `^[12]$`) against exact expected values for menu inputs rather than unbounded digit classes.
