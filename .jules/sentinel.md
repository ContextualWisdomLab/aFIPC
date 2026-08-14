## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2026-08-13 - Bound interactive binary choices before integer coercion
**Vulnerability:** A menu prompt accepted any digit string with `^[0-9]+$`; an out-of-range integer could coerce to `NA_integer_` and abort later condition evaluation.
**Learning:** Validate menu input against the documented value set before coercion.
**Prevention:** Use an exact bounded expression such as `^[12]$` for binary choices and retain a bounded retry limit.
