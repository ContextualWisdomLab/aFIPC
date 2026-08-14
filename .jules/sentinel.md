## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-16 - Fix readline integer coercion DoS vulnerability
**Vulnerability:** Weak regex `^[0-9]+$` for integer validation allows extremely large numeric strings, which coerce to `NA` via `as.integer()` and crash the R process when evaluated in `if` conditions.
**Learning:** When reading integer inputs via `readline()` in R, avoid weak regex validation. Large numbers coerce to `NA` breaking control flow logic.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` when prompting for specific integer options to prevent unexpected coercions and DoS vulnerabilities.
