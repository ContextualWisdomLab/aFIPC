## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-24 - [Integer Overflow DoS Risk in Interactive Prompts]
**Vulnerability:** Validating interactive `readline()` input with a broad regex `grepl("^[0-9]+$")` before calling `as.integer()` can lead to integer overflow, generating `NA` and crashing downstream checks if a very large string of numbers is provided.
**Learning:** This regex allows numbers larger than the maximum 32-bit integer supported by `as.integer()`.
**Prevention:** Always use strict string matching (e.g., `n %in% c("1", "2")`) when strictly predefined input options are expected.
