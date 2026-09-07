## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-12 - Fix missing parameter validations for readline
**Vulnerability:** Weak regex `^[0-9]+$` for `readline()` validation when coercing to integer is a security vulnerability. Inputs exceeding the 32-bit integer limit coerce to `NA`, breaking downstream logic.
**Learning:** In R, when validating `readline()` inputs intended for `as.integer()` coercion, always use strictly bounded exact-match regex.
**Prevention:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) for `readline()` inputs meant to be specific choices.
