## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-24 - Fix integer overflow coercion in input validation
**Vulnerability:** validating interactive numeric input using only regex `grepl("^[0-9]+$", n)` allows huge numeric strings to pass.
**Learning:** Extremely large numbers cause `as.integer()` coercion to integer overflow, returning `NA` and throwing a warning. Subsequent logical evaluations comparing to this `NA` will crash the application (DoS risk).
**Prevention:** Use strict exact-match validation (e.g., `n %in% c("1", "2")`) for predefined numeric option sets instead of regex.
