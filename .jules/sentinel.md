## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-13 - Fix weak regex validation for interactive inputs
**Vulnerability:** Weak regex `^[0-9]+$` for interactive inputs allowed excessively large numbers that coerced to NA via `as.integer()`, breaking `if` conditions and causing process crashes or DoS.
**Learning:** In R, `as.integer()` will coerce large numbers (e.g. out of bounds integers) to NA, which can crash control flows expecting single boolean values.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` for finite integer choices in `readline()` prompts to prevent unexpected coercions.
