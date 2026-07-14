## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-25 - Fix missing input validation in readline prompts
**Vulnerability:** Weak regex `^[0-9]+$` in interactive `readline()` prompts allowed arbitrarily large numeric strings to be passed. When cast via `as.integer()`, these resulted in `NA`, which bypassed conditionals and risked `condition has length > 1` process crashes (DoS).
**Learning:** `readline()` input representing exact integer choices (e.g. `1: Yes, 2: No`) must be validated using strictly bounded regex matching like `^[12]$`. Coercion functions (`as.integer()`) are not safe without prior bounding.
**Prevention:** Always use strictly bounded regular expressions when validating exact interactive inputs to prevent unexpected NA coercion crashes.
