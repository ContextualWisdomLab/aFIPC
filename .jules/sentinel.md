## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-30 - Integer Overflow Coercion Vulnerability with as.integer()
**Vulnerability:** Interactive `readline()` prompts validated input using unbounded regex `^[0-9]+$` before coercion with `as.integer()`.
**Learning:** This introduces a potential integer overflow coercion vulnerability (DoS). Excessively large numeric strings (e.g. `9999999999999999999999`) pass the regex check but overflow the max integer limit when evaluated by `as.integer()`, resulting in `NA` and causing downstream type errors or process crashes.
**Prevention:** Strictly match against exact expected values using bounded regular expressions (e.g. `^[12]$` instead of `^[0-9]+$`) when validating input choices prior to integer coercion.
