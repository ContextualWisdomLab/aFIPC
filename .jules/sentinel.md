## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-08-01 - Fix integer coercion DoS vulnerability in readline prompts
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline()` inputs allowed excessively large strings (e.g. "9999999999") to pass validation, which when coerced by `as.integer()` returned `NA`. This caused unhandled exceptions in subsequent `if` conditions, leading to unexpected crashes (Denial of Service).
**Learning:** Base `as.integer()` silently coerces out-of-bounds numeric strings to `NA` with a warning, bypassing simple digit-only regex checks.
**Prevention:** Use strictly bounded exact-match regex (like `^[12]$`) when validating interactive menu choices to guarantee safe integer coercion and prevent runtime crashes.
