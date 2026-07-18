## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-18 - [Weak regex check in `readline()` inputs causes Denial of Service]
**Vulnerability:** The code used weak regex like `^[0-9]+$` for boolean-like choices via `readline()`, which allowed users to enter huge strings or numbers that evaluate out-of-bounds in R, resulting in an unhandled exception or integer coercion failure.
**Learning:** `readline()` inputs in automated/interactive scripts require strict length/value matching rather than open-ended string matching. `^[0-9]+$` on a prompt that only accepts '1' or '2' is too permissive.
**Prevention:** Use strictly bounded matching like `^[12]$` when only specific inputs are acceptable.
