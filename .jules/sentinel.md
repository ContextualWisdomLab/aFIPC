## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-10-03 - Fix integer overflow DoS vulnerability in interactive prompts
**Vulnerability:** validating interactive `readline()` inputs using broad numeric regexes like `grepl('^[0-9]+$', n)` allows arbitrarily large integer strings to pass validation, leading to an integer overflow during `as.integer(n)`, which generates `NA` and crashes logical checks, causing a Denial of Service.
**Learning:** In R, `as.integer()` fails and returns `NA` for values outside the 32-bit signed integer range. Validating inputs strictly based on predefined expected string values is necessary.
**Prevention:** Always use exact string matching (e.g., `n %in% c('1', '2')`) when validating predefined string options from `readline()` before attempting any type coercion.
