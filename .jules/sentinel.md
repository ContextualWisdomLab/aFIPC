## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-02 - Fix integer coercion DoS vulnerability
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline()` user inputs allows huge numeric strings which coerce to `NA` when passed to `as.integer()`.
**Learning:** In R, evaluating `NA` inside an `if()` condition or returning `NA` from a function expected to return integers can break program logic or crash automation processes.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` when validating integer inputs intended to be explicitly mapped to fixed choices.
