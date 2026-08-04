# Sentinel Journal

## 2024-05-18 - Prevent Integer Overflow Coercion Vulnerability in Interactive Prompts

**Vulnerability:**
Interactive `readline()` prompts were validated using unbounded digit matching
(e.g., `grepl("^[0-9]+$", n)`). This allows an attacker to input excessively
large strings of numbers (e.g., "9999999999999999999999"), which pass the regex
check but when passed to `as.integer()` are coerced to `NA`. This causes the
script to crash or behave unexpectedly down the line since `NA` is not handled.

**Learning:**
Using overly permissive unbounded regex checks (like `^[0-9]+$`) for specific
menu selections fails to protect against bounds limits of integer data types.
Strict matching to exact required values is necessary.

**Prevention:**
Strictly match against exact expected values (e.g., `grepl("^[12]$", n)`)
rather than unbounded digit classes. This ensures that the input is exactly
one of the permitted options before coercion to integer.

## 2024-07-12 - Fix missing parameter validations

**Vulnerability:**
Unvalidated inputs passed to `if()` statements can cause process crashes
(`condition has length > 1`) or unexpected coercion vulnerabilities.

**Learning:**
In R, optional boolean parameters that default to `NULL` should be validated
using explicit runtime type validation (e.g.,
`if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).

**Prevention:**
Always implement explicit runtime type validation for optional boolean parameters.
