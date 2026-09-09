## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2023-09-09 - [Input Validation Fix]
**Vulnerability:** Use of a weak regex `^[0-9]+$` for user input that is passed to `as.integer()` via `readline()`.
**Learning:** The previous implementation allowed unbounded numeric inputs to be accepted. Since R limits integers to 32 bits, entering numbers that exceeded the limit would result in an `NA` coercion, breaking downstream logic that expected integers 1 or 2.
**Prevention:** Explicit and bounded match strings (e.g. `^[12]$` rather than generic quantifiers like `^[0-9]+$`) must be used for precise input control, matching strictly the set of options available (1 and 2).
