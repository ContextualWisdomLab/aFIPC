## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2026-09-24 - [Fix integer overflow risk in interactive input validation]
**Vulnerability:** Relied on loose regex `grepl("^[0-9]+$")` for `readline()` input.
**Learning:** R's `as.integer()` returns `NA` for extremely large numbers that pass the regex. This can crash the application or bypass logic (DoS) when evaluated.
**Prevention:** Use strict exact-match whitelist (e.g., `n %in% c("1", "2")`) for predefined option sets.
