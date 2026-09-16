## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-16 - Prevent unexpected NA coercion in readline by strengthening regex validation limits
**Vulnerability:** Weak regex `^[0-9]+$` on interactive `readline()` allows users to input arbitrarily large integers (e.g., `10000000000000000000`), which causes integer overflow and silent `NA` coercion in R. Downstream code then compares against `NA`, causing logical errors or crashes (`condition has length > 1`).
**Learning:** In R, input intended for `as.integer()` coercion must be strictly bounded when read from standard input, because values exceeding the 32-bit limit coerce to `NA` with a warning that often goes ignored.
**Prevention:** Always use exact-match regex (e.g., `^[12]$`) that restricts the character length to valid options rather than accepting any sequence of digits.
