## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-05-18 - Fix readline integer coercion DoS
**Vulnerability:** Weak regex validation like `^[0-9]+$` for `readline()` inputs allows extremely large numbers that coerce to `NA` via `as.integer()`, breaking `if` conditions and causing unhandled exceptions.
**Learning:** Using `as.integer()` on unbounded numeric strings can result in `NA_integer_` warnings, which crashes logical conditions and enables local denial-of-service in interactive sessions.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` when only specific choices are valid.
