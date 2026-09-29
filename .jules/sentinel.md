## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2026-09-29 - Integer Overflow in Interactive Input Validation
**Vulnerability:** Integer overflow crashing downstream logic due to unbounded regex validation in readline().
**Learning:** Using `grepl("^[0-9]+$")` allows inputs exceeding R's max integer (2147483647). `as.integer()` converts these to `NA`, causing `if (NA)` crash.
**Prevention:** Validate interactive input against exact expected string values (e.g., `n == "1" || n == "2"`) before type coercion.
