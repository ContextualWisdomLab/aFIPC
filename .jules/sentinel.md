## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-23 - [Interactive Input Integer Overflow DoS]
**Vulnerability:** validating interactive numeric inputs using generic regex matching like `grepl("^[0-9]+$", n)` prior to `as.integer(n)` coercion allows extremely large strings to be evaluated as NA, causing unhandled application crashes in subsequent logical statements.
**Learning:** reliance on regex-based numerical character evaluation is flawed since R coercions have system-level limits that cause silent NA generation without failing the regex match.
**Prevention:** always use exact-match validation lists like `n %in% c("1", "2")` to safely and strictly restrict inputs.
