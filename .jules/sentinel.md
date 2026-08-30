## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-30 - Fix weak regex validation for integer coercion
**Vulnerability:** Weak regex `^[0-9]+$` on interactive inputs allowed arbitrarily large integers which coerce to `NA` in `as.integer()`, causing unhandled exceptions (DoS risk).
**Learning:** When validating single-digit interactive choices (e.g. 1 or 2) from strings, overly permissive regex exposes the application to unexpected NA coercion failures.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` for specific choice inputs to prevent coercion crashes.
