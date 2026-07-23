## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2026-07-23 - [Input Validation and Coercion Vulnerability]
**Vulnerability:** Weak regex validation (`^[0-9]+$`) for interactive prompts allowed inputs that, when passed to `as.integer()`, resulted in `NA` values. This would cause downstream logic to break, leading to unhandled exceptions and a potential Denial of Service (DoS) in automated or pseudo-interactive setups.
**Learning:** `as.integer()` can return `NA` for values that match simple numeric patterns but are too large or malformed.
**Prevention:** Strictly bound expected input ranges in validation logic (e.g., `^[12]$`) before converting to types that might trigger `NA` coercion.
