## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2026-08-06 - Fix weak regex for readline validation
**Vulnerability:** Weak regex `^[0-9]+$` allows large numbers that coerce to NA, crashing the process (DoS).
**Learning:** Interactive integer prompts need exact-match bounded regex (e.g. `^[12]$`) instead of unbounded digits.
**Prevention:** Use strictly bounded regular expressions when parsing integer choices.
