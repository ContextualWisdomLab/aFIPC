## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-16 - DoS risk from weak readline regex validation
**Vulnerability:** The regex validation for `readline()` inputs in `aFIPC.R` used `^[0-9]+$` which permitted large numbers that could result in coercion failures, unhandled exceptions, and potentially application crashes (Denial of Service).
**Learning:** `as.integer()` coercions on weakly bounded string lengths can yield `NA` and bypass downstream integer checks, failing conditionals.
**Prevention:** Bound string validations tightly. Changed the regex pattern to strictly match valid choices: `^[12]$`.
