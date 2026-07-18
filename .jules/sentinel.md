## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-18 - Fix Integer Overflow Coercion in readline Input Validation
**Vulnerability:** In `R/aFIPC.R`, the application used a permissive regex `^[0-9]+$` to validate numeric interactive inputs from `readline()` before coercing them with `as.integer()`. An attacker could input an excessively long numeric string (e.g., `999999999999999999999`), which bypasses the regex check but evaluates to `NA` during coercion, leading to an unexpected state or subsequent process crashes due to integer overflow.
**Learning:** R's `as.integer()` fails silently with a warning and returns `NA` when given numbers exceeding the 32-bit integer limits, making broad regex checks like `^[0-9]+$` insufficient for safe parsing of integer inputs intended for program control flow.
**Prevention:** Always match against the specific, finite set of expected valid inputs (e.g., `^[12]$`) when validating numerical inputs from `readline()` before parsing, preventing integer overflow and logic bypass vulnerabilities.
