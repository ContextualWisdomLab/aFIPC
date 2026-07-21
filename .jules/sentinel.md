## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-21 - Fix DoS risk in interactive prompts
**Vulnerability:** Weak regex validation (`^[0-9]+$`) in interactive `readline()` prompts allowed very large numbers which coercing to `NA` when evaluated with `as.integer()`. When passed to an `if` statement, this caused unhandled exception errors (`condition has length > 1` in modern R versions).
**Learning:** `readline()` input can be manipulated with extremely large numbers resulting in unexpected coercion failures.
**Prevention:** Strictly bound expected input in `readline()` routines using an exact match regex like `^[12]$` instead of `^[0-9]+$`.
