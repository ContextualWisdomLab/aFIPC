## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-10-02 - Fix readline Integer Overflow DoS vulnerability
**Vulnerability:** Validating interactive inputs from `readline()` using broad numeric regexes (e.g., `grepl('^[0-9]+$')`) before coercing with `as.integer()` can lead to integer overflow DoS vulnerabilities (producing `NA` and crashing logic checks).
**Learning:** In R packages, validating strictly predefined interactive input from `readline()` using broad numeric regexes before coercing with `as.integer()` can lead to integer overflow DoS vulnerabilities.
**Prevention:** Always use exact string matching (e.g., `n %in% c('1', '2')`) for predefined options.
