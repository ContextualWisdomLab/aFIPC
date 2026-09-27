## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-27 - Fix unconstrained integer validation
**Vulnerability:** Unconstrained regex matching `grepl("^[0-9]+$", n)` allows excessively large numbers to be converted by `as.integer(n)`, resulting in integer overflow (`NA` warning) which crashes downstream conditional checks expecting a boolean or integer outcome.
**Learning:** In R, validating input bounds is important especially for menu selections. Overly broad regexes leave the type coercion vulnerable to overflow logic errors.
**Prevention:** Rather than regex checks and coercion, validate the raw string explicitly against expected enum values (e.g., `n == "1" || n == "2"`) to safely guard internal logic flow.
