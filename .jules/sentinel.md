## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-11 - Integer Coercion DoS via Weak Regex
**Vulnerability:** Weak regex `^[0-9]+$` allowed arbitrarily large numbers to pass validation during `readline()` inputs, leading to `NA` coercion by `as.integer()` and subsequent unhandled exceptions / Denial of Service.
**Learning:** R's `as.integer()` returns `NA` with a warning for numeric inputs exceeding `INT_MAX`, which can break subsequent `if` condition checks causing crashes.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` for integer menu choices to prevent unexpected type coercions and DoS vulnerabilities.
