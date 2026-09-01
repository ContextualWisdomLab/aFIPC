## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2025-02-12 - Fix missing value where TRUE/FALSE needed vulnerability
**Vulnerability:** Weak regex `^[0-9]+$` allowing extremely large strings to be interpreted as numbers in `readline()` inputs, causing `NA` coercion by `as.integer()` and crashing `if()` blocks (`missing value where TRUE/FALSE needed`).
**Learning:** When reading integer inputs via `readline()` in R, avoid weak regex validation like `^[0-9]+$` as large numbers coerce to `NA` via `as.integer()`, breaking `if` conditions and causing unhandled exceptions. Use strictly bounded exact-match regex like `^[12]$` to prevent coercion crashes and DoS vulnerabilities.
**Prevention:** Always bound expected integer inputs and use strict validation like `^[12]$` when expecting a finite set of answers.
