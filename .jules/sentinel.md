## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-13 - Prevent Integer Coercion DoS in readline
**Vulnerability:** Weak regex `^[0-9]+$` allows large numbers that coerce to `NA` when parsed by `as.integer()`, causing a crash/DoS in subsequent `if` condition checks.
**Learning:** Always use strictly bounded exact-match regex like `^[12]$` to prevent coercion crashes when reading integer inputs via `readline()` in R.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` instead of `^[0-9]+$` for menu choices.
