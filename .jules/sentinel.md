## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-25 - Fix integer overflow vulnerability in readline
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline` input allows integers exceeding the 32-bit limit to be passed to `as.integer()`, resulting in `NA` coercion and downstream logic failure.
**Learning:** In R, when validating inputs for strict coercion (like `as.integer()`), broad regex patterns are a security vulnerability. Inputs larger than the maximum integer value will be cast to `NA`.
**Prevention:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) for menu selections or exact digit counts for IDs to prevent overflow coercion vulnerabilities.
