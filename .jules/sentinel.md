## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-10-01 - Fix Integer Overflow DoS in interactive prompts
**Vulnerability:** Validating interactive `readline()` input with broad numeric regexes like `grepl('^[0-9]+$')` before coercing to integer can lead to integer overflow DoS vulnerabilities when large values produce `NA` and crash logic checks.
**Learning:** In R, `as.integer()` returns `NA` with a warning for values outside the 32-bit integer range.
**Prevention:** Always use exact string matching (e.g., `n %in% c('1', '2')`) for predefined options rather than broad regex validation.
