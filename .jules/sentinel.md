## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-09-24 - Fix interactive readline integer coercion limits
**Vulnerability:** Unbounded regex matching `^[0-9]+$` on interactive `readline()` input allows massive digit strings, causing `as.integer()` to silently overflow and return `NA`, bypassing conditional bounds.
**Learning:** `as.integer` on large numbers returns `NA` and warns. This crashes downstream logic relying on valid integers.
**Prevention:** Always validate exact string values from `readline` (e.g., `n == "1" || n == "2"`) instead of broad regexes before parsing to integer.
