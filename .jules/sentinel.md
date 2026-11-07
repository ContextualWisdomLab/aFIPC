## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-09-26 - [CRITICAL] Fix integer overflow coercion in input validation
**Vulnerability:** Unvalidated large string inputs passed to `as.integer()` after regex bypass `grepl("^[0-9]+$")` cause integer overflow and return `NA`, leading to potential crash/DoS when evaluated later.
**Learning:** In R, `as.integer()` will evaluate excessively large numbers to `NA` with a warning, bypassing basic regex numeric checks.
**Prevention:** Always use strict exact-match string validation (e.g., `n %in% c("1", "2")`) rather than regex when expecting specific predetermined numeric options in interactive prompts.
