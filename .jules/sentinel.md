## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-05-18 - [Integer Overflow DoS in `readline()` Input Validation]
**Vulnerability:** Broad numeric regex validation (`grepl("^[0-9]+$", n)`) allowed arbitrary length numerical strings from user input to be parsed. When coerced via `as.integer(n)`, integer overflows resulted in `NA` values and warning messages, which could crash logic checks (DoS).
**Learning:** `readline()` input representing predefined options should be strictly checked against the expected literal string options (e.g., `n %in% c("1", "2")`) rather than allowing open-ended regex number matching prior to coercion.
**Prevention:** Always validate categorical or strict-menu interactive inputs using exact string matching (`%in%`) before type coercion.
