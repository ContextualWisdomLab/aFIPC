## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-20 - Fix weak regex validation for integer coercion
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline()` inputs allows large numbers that coerce to `NA` via `as.integer()`, breaking downstream `if` conditions and causing application crashes.
**Learning:** Relying on unbounded numeric regex for bounded choice menus (e.g., 1 or 2) leaves the application vulnerable to input coercion DoS.
**Prevention:** Always use strictly bounded exact-match regex like `^[12]$` when validating choice-based integer inputs to prevent `NA` coercion crashes.
