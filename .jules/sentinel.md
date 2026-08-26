## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-08-26 - Fix regex validation to prevent NA coercion crashes
**Vulnerability:** Weak regex validation (`^[0-9]+$`) allows large numeric strings to be passed to `as.integer()`, which coerces them to `NA`, causing runtime crashes (`missing value where TRUE/FALSE needed`) when evaluated in conditionals.
**Learning:** When reading integer inputs via `readline()` in R, avoid weak regex validation like `^[0-9]+$` as large numbers coerce to `NA` via `as.integer()`.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` for categorical numeric choices to prevent coercion crashes and DoS vulnerabilities.
