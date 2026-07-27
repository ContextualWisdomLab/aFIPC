## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-27 - [Integer Overflow Coercion Vulnerability]
**Vulnerability:** Unbounded regex for digit matching (`^[0-9]+$`) allows excessively large numeric strings to pass validation, causing `as.integer()` to return NA and crash the process.
**Learning:** `readline()` input validation must strictly match expected values, not just unbounded digits, to prevent integer overflow coercion.
**Prevention:** Use strictly bounded regex patterns (e.g., `^[12]$`) when validating finite sets of acceptable interactive numeric inputs.
