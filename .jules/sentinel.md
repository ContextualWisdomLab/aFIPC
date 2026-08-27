## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-27 - Fix unhandled NA coercion crash in interactive prompts
**Vulnerability:** Weak regex `^[0-9]+$` on interactive integer inputs allows large numbers which coerce to `NA` via `as.integer()`, breaking `if` conditions and causing unhandled exceptions.
**Learning:** Using overly permissive regex for bounded integer choices exposes the application to coercion crashes.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` when reading integer choices via `readline()` in R to prevent coercion crashes.
