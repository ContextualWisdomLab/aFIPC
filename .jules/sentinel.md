## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2023-10-24 - Fix Integer Overflow Coercion Vulnerability in Interactive Prompts
**Vulnerability:** Input validation for `readline()` prompts used an unbounded regex (`grepl("^[0-9]+$", n)`), which allowed arbitrary large digit strings. This caused `as.integer()` coercion to fail and return `NA`, resulting in unexpected downstream behavior.
**Learning:** Using `as.integer()` on unbounded numeric strings without bounds checking risks integer overflow in R, leading to silent `NA` coercion.
**Prevention:** For menu prompts with small fixed options (e.g., 1 or 2), validate inputs against exact string matching (e.g., `n == "1" || n == "2"`) rather than relying on unbounded regular expressions and subsequent type coercion.
