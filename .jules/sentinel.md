## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-08-01 - Fix integer coercion vulnerabilities in interactive prompts
**Vulnerability:** Weak regex `^[0-9]+$` allows large strings of digits that evaluate to `NA` when coerced by `as.integer()`, crashing conditional branches.
**Learning:** `readline()` input expected to be bounded must be strictly validated with exact-match regex (e.g., `^[12]$`) instead of unbounded digit captures.
**Prevention:** Always use strictly bounded regex for integer input validation from user prompts.
