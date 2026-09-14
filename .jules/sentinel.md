## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-14 - Fix weak regex validation for readline inputs
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline` inputs allows passing arbitrarily large numbers that exceed the 32-bit integer limit, resulting in coercion to `NA` when passed to `as.integer()` and breaking downstream logic.
**Learning:** When validating `readline()` inputs intended for `as.integer()` coercion, using unbounded regex like `^[0-9]+$` is a security vulnerability because inputs exceeding the 32-bit integer limit coerce to `NA`.
**Prevention:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) when parsing integer choices to prevent coercion to `NA`.
