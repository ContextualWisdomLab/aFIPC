## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-13 - Fix DoS vulnerability in readline integer coercion
**Vulnerability:** Weak regex validation (`^[0-9]+$`) allows large numbers to be entered in `readline()` which coerces to `NA` via `as.integer()`, breaking `if` conditions and causing unhandled exceptions.
**Learning:** In R, large integer inputs coerce to `NA` leading to unexpected vulnerabilities.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` to prevent coercion crashes and DoS vulnerabilities.
