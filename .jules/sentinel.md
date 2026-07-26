## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-26 - Integer Coercion Vulnerability from readline()
**Vulnerability:** When reading integer inputs via `readline()` in R, weak regex validation like `^[0-9]+$` allows large numbers that coerce to `NA` via `as.integer()`, which can break `if` conditions and cause unhandled exceptions.
**Learning:** This weak validation can lead to crashes and Denial of Service (DoS) vulnerabilities when large input bypasses length limits or expected integer bounds.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` for options selection to prevent coercion crashes and ensure inputs are within acceptable boundaries before converting to integer.
