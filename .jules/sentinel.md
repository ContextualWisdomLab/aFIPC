# Sentinel Journal

## 2024-07-12 - Fix missing parameter validations

**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-13 - Fix integer overflow coercion vulnerability in readline input

**Vulnerability:** Interactive `readline()` user inputs that are loosely validated against unbounded digit classes (e.g., `^[0-9]+$`) can evaluate to `NA` when passed to `as.integer()` if the string represents an excessively large number, which leads to integer overflow coercion vulnerabilities and possible process crashes.
**Learning:** For R scripts, any validation on interactive `readline()` numeric inputs should strictly match against exact expected values (e.g., `^[12]$`) rather than unbounded digit classes.
**Prevention:** Strictly validate `readline()` inputs against expected discrete values instead of using unbounded numerical regular expressions.
