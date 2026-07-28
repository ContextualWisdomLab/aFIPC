## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-28 - Fix integer overflow coercion in readline input validation
**Vulnerability:** Unbounded digit class regex (e.g., `^[0-9]+$`) used for validating user input expecting a single-digit integer choice allows extremely large numeric strings to pass the regex check, which subsequently evaluate to `NA` in `as.integer(n)`. This causes a process crash due to `missing value where TRUE/FALSE needed`.
**Learning:** When validating interactive `readline()` numeric inputs in R, unbounded regex checks allow integer overflow coercion vulnerabilities.
**Prevention:** Strictly match against exact expected values (e.g., `^[12]$`) instead of using unbounded digit classes to ensure the input evaluates safely and correctly.
