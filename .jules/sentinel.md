## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-09-06 - Strict regex bounding for user input coercion
**Vulnerability:** Weak regex `^[0-9]+$` on interactive user inputs allowed arbitrarily large values that exceed the 32-bit integer limit, resulting in `NA` values and breaking downstream logic when coerced using `as.integer()`.
**Learning:** Coercion functions like `as.integer()` have strict limits. Inputs must be strictly bounded to the exact expected choices rather than a general character class when the only valid inputs are "1" or "2".
**Prevention:** Always use exact-match bounded regex (e.g., `^[12]$`) for fixed-choice integer coercion from string inputs.
