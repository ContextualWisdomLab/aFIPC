## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-18 - [CRITICAL] Prevent Integer Overflow Coercion in readline Input Validation
**Vulnerability:** Interactive `readline()` prompts for binary choices (e.g., '1' or '2') in `autoFIPC` incorrectly validated input using the unbounded regular expression `^[0-9]+$`. This allows arbitrarily large numeric strings (e.g., "999999999999999999999") to pass the regex check, which subsequently evaluates to `NA` when coerced via `as.integer()`, potentially causing unhandled exceptions or process crashes.
**Learning:** The previous validation implementation used `^[0-9]+$` allowing unbounded numeric digits, assuming `as.integer()` would handle it securely. However, R's `as.integer()` returns `NA` with a warning for out-of-range large integers, which leaks into subsequent logic that expects an integer.
**Prevention:** Strictly limit allowed character patterns matching exact expected literal values (e.g., `^[12]$`) instead of generic type structures (e.g., all digits) when validating string inputs bound for type coercion or conditionals.
