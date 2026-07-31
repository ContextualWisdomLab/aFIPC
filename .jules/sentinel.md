## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-19 - Strict input validation for numeric interactive prompts
**Vulnerability:** Interactive `readline()` prompts using unconstrained numeric regex matching (e.g., `^[0-9]+$`) can accept excessively large numbers (like `'9999999999999999999'`). When these strings are coerced using `as.integer()`, they can evaluate to `NA`, leading to integer overflow coercion vulnerabilities and downstream process crashes.
**Learning:** In R, input validation regex for expected numeric inputs should explicitly match the exact expected values rather than generic digit classes.
**Prevention:** When validating interactive `readline()` numeric inputs, strictly match against exact expected values (e.g., `^[12]$`) instead of unbounded digit classes (e.g., `^[0-9]+$`).
