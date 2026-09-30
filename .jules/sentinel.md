## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-09-30 - Fix integer coercion vulnerabilities in interactive prompts
**Vulnerability:** Unbounded regex validation (`grepl("^[0-9]+$")`) allows inputs exceeding R's max integer limit, which coerces to `NA` (integer overflow) and can crash downstream conditional checks or bypass logic.
**Learning:** In R, validating interactive inputs (`readline()`) intended as small integers should avoid unbounded regex patterns.
**Prevention:** Validate the input against specific expected string values (e.g., `n == "1" || n == "2"`) before coercing to integer.
