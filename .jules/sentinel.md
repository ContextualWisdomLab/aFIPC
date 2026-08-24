## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-24 - Fix integer coercion vulnerabilities in interactive prompts
**Vulnerability:** Weak regex `^[0-9]+$` allows arbitrarily large numbers in `readline()`, which coerce to `NA` in `as.integer()`, potentially causing unhandled exceptions or DoS.
**Learning:** Always use strictly bounded exact-match regex like `^[12]$` when validating integer inputs from users to prevent coercion crashes.
**Prevention:** Use strictly bounded exact-match regex (`^[12]$` instead of `^[0-9]+$`) for menu selections.
