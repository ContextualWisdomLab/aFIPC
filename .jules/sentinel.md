# Sentinel Journal

## 2024-07-12 - Fix missing parameter validations

**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause
process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be
validated using explicit runtime type validation (e.g.,
`if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional
boolean parameters.

## 2024-07-13 - Fix integer overflow coercion vulnerability in readline input validation

**Vulnerability:** Weak regex `^[0-9]+$` allows excessive numeric strings that
coerce to `NA` inside `as.integer()`, which can lead to unhandled process crashes.
**Learning:** `readline()` validation should strictly match exact expected bounds
for interactive prompts instead of open-ended digit validation to prevent
integer overflow coercion.
**Prevention:** Strictly match against exact expected values (e.g., `^[12]$`)
instead of unbounded digit classes when validating user inputs mapped to integers.
