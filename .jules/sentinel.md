## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-26 - Strict bounded regex for interactive inputs
**Vulnerability:** Weak regex like `^[0-9]+$` on interactive `readline` inputs allows large integers to be entered, which coerce to `NA` in `as.integer()`, bypassing subsequent logic and causing unhandled exceptions or DoS vulnerabilities.
**Learning:** Using strictly bounded regex, like `^[12]$`, prevents parsing errors and protects the program flow from unexpected user input.
**Prevention:** Always validate interactive inputs with exact bounded regex before coercion.
