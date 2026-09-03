## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-12 - Fix weak regex validation for integer coercion
**Vulnerability:** Weak regex validation (`^[0-9]+$`) for `readline()` inputs allows extremely large numbers (e.g. `9999999999999999999999`) to be parsed. When coerced via `as.integer()`, these large strings turn into `NA` rather than numbers, breaking downstream `if` conditions and causing unhandled exceptions/DoS vulnerabilities.
**Learning:** R's `as.integer()` fails silently with `NA` (along with a warning) when it encounters numbers larger than a 32-bit integer limits, making broad regex digit validation insufficient for inputs meant to be coerced to integers.
**Prevention:** Use strictly bounded exact-match regex (e.g., `^[12]$`) to validate inputs intended for discrete integer coercion prior to calling `as.integer()`.
