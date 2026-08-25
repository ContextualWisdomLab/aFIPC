## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-25 - Fix missing bounded validation for readline inputs
**Vulnerability:** Unbounded numeric regex validation (e.g., `^[0-9]+$`) for `readline()` allows large inputs that coerce to `NA` via `as.integer()`. This causes downstream `if (variable == 1)` conditions to fail with a `missing value where TRUE/FALSE needed` error, resulting in unhandled exception crashes.
**Learning:** When reading integer inputs for binary choices, using bounded exact-match regex like `^[12]$` is necessary to prevent coercion crashes and Denial of Service (DoS) vulnerabilities in interactive environments.
**Prevention:** Always use strict and bounded regex validation for `readline()` input instead of broad numeric matching.
