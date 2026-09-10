## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-09-10 - Strict interactive input validation
**Vulnerability:** Weak regex `^[0-9]+$` on interactive inputs allowed overflow integers, bypassing integer conversion safety boundaries and causing `NA` coercion breakages downstream.
**Learning:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) when checking `readline()` inputs for constrained menu options.
**Prevention:** Use stricter regex validations for interactive prompts rather than general numeric validations.
