## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-10-24 - [Integer Overflow DoS in Interactive Prompts]
**Vulnerability:** Input validation using `grepl("^[0-9]+$", n)` allows arbitrarily long numeric strings, which cause integer overflow and yield `NA` when coerced via `as.integer()`. This can lead to application crashes (Denial of Service) when evaluated in subsequent boolean logic.
**Learning:** Regular expressions checking for digits do not account for data type limits (like maximum integer size in R). Relying on regex alone for numeric validation is insufficient when the inputs are coerced to restricted types.
**Prevention:** Always use strict exact-match validation (e.g., `n %in% c("1", "2")`) when handling predefined option sets from user inputs to ensure robust type safety and prevent coercion errors.
