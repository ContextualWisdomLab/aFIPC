## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-08 - Fix missing input validation leading to NAs
**Vulnerability:** Weak regex `grepl("^[0-9]+$", n)` allows large numbers that coerce to `NA` via `as.integer()`, potentially causing unhandled exceptions in conditionals.
**Learning:** Always use tightly bounded exact-match regex like `grepl("^[12]$", n)` when validating user inputs for integer choices to avoid coercion crashes and DoS vulnerabilities.
**Prevention:** Strictly bound input validation regexes for choices.
