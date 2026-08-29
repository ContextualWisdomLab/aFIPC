## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-28 - Fix integer coercion DoS vulnerability via interactive readline
**Vulnerability:** Interactive `readline()` prompts parsing integers via `as.integer()` were loosely validated with `^[0-9]+$`. Large inputs coerced to `NA`, breaking `if` conditionals and causing crashes (Denial of Service).
**Learning:** Weak regex for integers is dangerous since R's 32-bit limits can easily cause silent `NA` generation upon coercion.
**Prevention:** Strictly bound validations for menu prompts (e.g., `^[12]$` instead of `^[0-9]+$`).
