## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2026-10-01 - Prevent Integer Overflow in Interactive Prompt Validation
**Vulnerability:** Unbounded regex like `grepl("^[0-9]+$", ...)` followed by `as.integer()` when parsing interactive inputs can lead to integer overflow (`NA_integer_`) if the user inputs an exceedingly large number, which could cause downstream logic or conditional checks to crash unexpectedly.
**Learning:** Checking against an unbounded regular expression does not guarantee safe integer coercion in R due to the max integer limit.
**Prevention:** Always validate interactive input values against a strict list of expected strings (e.g., `n == "1" || n == "2"`) before coercing or processing them.
