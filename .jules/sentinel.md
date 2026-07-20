## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-20 - Prevent Integer Overflow Coercion Vulnerability in Interactive Prompts
**Vulnerability:** Unbounded digit classes (`^[0-9]+$`) in interactive input validation allow excessively large numeric strings that evaluate to `NA` when coerced with `as.integer()`, which could lead to downstream crashes.
**Learning:** `readline()` input validation should strictly match the exact expected options (e.g., `^[12]$`) rather than generic digit patterns.
**Prevention:** Always use precise regex patterns limiting the length and allowed characters when validating inputs intended for integer conversion in R.
