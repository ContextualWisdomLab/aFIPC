## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-31 - Fix Denial of Service in readline integer coercions
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline()` user inputs allows abnormally large integers that will coerce to `NA` when evaluated via `as.integer()`. This can cause unhandled exceptions and infinite loops/crashes when the `NA` value is evaluated in downstream logic.
**Learning:** In R, strings representing integers larger than `.Machine$integer.max` coerce to `NA`.
**Prevention:** Use strictly bounded exact-match regex validations (e.g., `^[12]$`) for expected input formats to prevent coercion crashes and limit input lengths.
