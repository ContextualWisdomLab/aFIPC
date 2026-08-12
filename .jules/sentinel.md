## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-25 - Fix weak regex validation in readline prompt
**Vulnerability:** Weak regex `^[0-9]+$` was used to validate integer inputs from `readline()`.
**Learning:** Large numeric inputs bypass this validation, are coerced to `NA` by `as.integer()`, and cause execution crashes (DoS) when used in conditionals.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` to prevent coercion crashes and DoS vulnerabilities.
