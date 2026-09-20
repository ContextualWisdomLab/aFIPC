## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-20 - Fix readline regex for unbounded integer limit coercion vulnerability
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline()` user inputs allows passing strings larger than the 32-bit integer limit, causing `as.integer()` to silently coerce to `NA` breaking downstream type expectations.
**Learning:** In R, input validation for exact match choices (e.g. 1 or 2) shouldn't allow unbounded digits if it's meant to coerce to a limited integer set.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` instead of `^[0-9]+$` when validating limited choices to prevent unintended coercion errors.
