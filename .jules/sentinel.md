## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-09-19 - Fix Integer Overflow in readline validation
**Vulnerability:** Weak numeric regex `^[0-9]+$` for `readline()` inputs intended for `as.integer()` coercion causes integer overflows. Inputs exceeding the 32-bit integer limit coerce to `NA`, potentially breaking downstream logic or causing crashes.
**Learning:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) when expecting specific small integer values from user input.
**Prevention:** Use strictly bounded regular expressions when parsing numeric options from user interactive sessions.
