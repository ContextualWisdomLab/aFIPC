## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-02 - Fix integer overflow coercion vulnerability in interactive prompts
**Vulnerability:** Integer overflow coercion vulnerability where excessively large numeric strings pass the `^[0-9]+$` regex check but evaluate to `NA` in `as.integer()`, causing subsequent process crashes.
**Learning:** When validating interactive `readline()` numeric inputs, strictly match against exact expected values (e.g., `^[12]$`) rather than unbounded digit classes (e.g., `^[0-9]+$`).
**Prevention:** Always strictly match against exact expected values when validating inputs that evaluate to integers.
