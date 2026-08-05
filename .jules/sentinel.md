## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-05 - Fix integer overflow coercion vulnerability in readline() inputs
**Vulnerability:** Interactive prompts using `readline()` validated numeric inputs with an unbounded digit class regex (`^[0-9]+$`). This could allow excessively large numeric strings (e.g. "999999999999999") to pass the check, but then evaluate to `NA` when passed to `as.integer()`. This can cause subsequent process crashes or unexpected logical paths.
**Learning:** In R, unbounded numeric strings do not automatically translate to valid integers due to maximum integer limits (`.Machine$integer.max`). When using `as.integer()` on validated strings, the regex must bound the length or, preferably, match exactly the expected values to prevent coercion to `NA`.
**Prevention:** Strictly match against exact expected values (e.g., `^[12]$`) instead of unbounded digit classes (`^[0-9]+$`) when validating `readline()` inputs that are expected to be specific integer options.
