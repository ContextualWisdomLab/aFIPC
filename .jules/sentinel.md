## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-10-02 - Integer Overflow via Unbounded Regex in Interactive Prompts
**Vulnerability:** Unbounded regex validation (`grepl("^[0-9]+$", n)`) followed by `as.integer()` in interactive prompts allows arbitrarily large inputs, causing an integer overflow `NA` that crashes downstream logic.
**Learning:** In R, inputs exceeding the maximum integer limit coerce to `NA` with a warning, bypassing intended type checks if unhandled.
**Prevention:** Validate interactive inputs intended as small integers against specific expected string values (e.g., `n == "1" || n == "2"`).
