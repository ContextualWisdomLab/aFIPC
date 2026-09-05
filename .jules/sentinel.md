## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2026-09-05 - Fix unsafe regex validation for readline inputs
**Vulnerability:** Weak regex `^[0-9]+$` for `readline()` inputs intended for `as.integer()` coercion. Inputs exceeding the 32-bit integer limit coerce to `NA`, breaking downstream logic.
**Learning:** Using unbounded numeric regex for bounded integer choices is a security vulnerability because it allows large numbers that overflow R's 32-bit integer limit.
**Prevention:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) for integer choices.
