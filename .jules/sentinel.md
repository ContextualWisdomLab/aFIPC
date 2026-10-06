## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-10-06 - Fix Integer Overflow Crash in Interactive Prompts
**Vulnerability:** Unbounded regex validation `grepl("^[0-9]+$", n)` followed by `as.integer(n)` for inputs like `readline()` causes R integer overflow when users input huge numbers (e.g., `999999999999999999`), resulting in `NA` coercion. Downstream `if` checks then fail with `missing value where TRUE/FALSE needed`.
**Learning:** In R, validating interactive integer inputs with unbounded regex is unsafe due to `as.integer()` limits.
**Prevention:** Validate interactive inputs against specific expected string values (e.g., `n == "1" || n == "2"`) before type conversion to prevent integer overflow and downstream process crashes.
