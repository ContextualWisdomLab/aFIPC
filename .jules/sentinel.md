## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-13 - Fix weak regex validation leading to DoS
**Vulnerability:** Weak regex `^[0-9]+$` allows large numbers that coerce to `NA` via `as.integer()`, bypassing conditions and causing runtime exceptions.
**Learning:** In R, unbounded integer matching combined with `as.integer()` can create denial-of-service risks due to `NA` coercion.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` for finite choice prompts to prevent coercion crashes.
