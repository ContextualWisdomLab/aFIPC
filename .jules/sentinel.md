## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-20 - Integer Coercion DoS Vulnerability in `readline()` Parsing
**Vulnerability:** Weak regex `grepl("^[0-9]+$", n)` was used to validate integer inputs from interactive `readline()` prompts before passing them to `as.integer()`.
**Learning:** Large numbers provided by users can pass the `^[0-9]+$` regex but fail to coerce properly via `as.integer()`, resulting in `NA`. This causes unhandled exceptions when evaluating the `if` conditions, leading to Denial of Service (DoS) in automated or interactive contexts.
**Prevention:** Always use strictly bounded exact-match regex (e.g., `^[12]$`) for constrained numeric choices to prevent `NA` coercion crashes.
