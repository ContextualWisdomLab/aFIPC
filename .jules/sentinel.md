## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2026-09-17 - Fix weak regex validation in readline inputs
**Vulnerability:** Weak regex `^[0-9]+$` on interactive menu prompts allowed integer overflow. Large inputs coerce to `NA` when passed to `as.integer()`, bypassing subsequent checks and causing downstream failures or vulnerabilities.
**Learning:** In R, validating `readline()` input destined for `as.integer()` requires strictly bounded exact-match regex rather than generic numeric matching to prevent coercion to `NA` from exceeding the 32-bit limit.
**Prevention:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) for fixed-choice interactive inputs.
