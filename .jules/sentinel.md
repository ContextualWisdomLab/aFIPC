## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-24 - [CRITICAL] Prevent Integer Overflow Coercion in Interactive Prompts
**Vulnerability:** Interactive `readline()` prompt validations were using unbounded digit classes (`^[0-9]+$`) to match single-digit numeric inputs (e.g., "1" or "2").
**Learning:** This approach enables integer overflow coercion vulnerabilities. When an excessively large numeric string is passed, it matches the regex but evaluates to `NA` when coerced via `as.integer()`. This allows unexpected values to bypass the validation and can cause subsequent process crashes (Denial of Service) when passed to downstream logic expecting a valid integer.
**Prevention:** Strictly match against the exact expected values (e.g., `^[12]$`) rather than unbounded digit classes when validating interactive `readline()` numeric inputs.
