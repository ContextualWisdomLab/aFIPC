## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-13 - [Strict Input Validation on Interactive Prompts]
**Vulnerability:** Unhandled coercion NA exception due to weak integer input validation (`^[0-9]+$`). If a user inputs a massive string (e.g., `"99999999999"`) into `readline()`, `as.integer()` coerces it to `NA`, which then crashes the `if` checks, causing a Denial of Service.
**Learning:** R does not inherently limit input string length in `readline()` nor does `as.integer()` catch out-of-bound overflow gracefully without introducing an `NA`. Checking for merely `[0-9]+` allows oversized integers.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` when reading constrained inputs to ensure coercion functions like `as.integer()` never encounter out-of-bound, `NA`-producing values.
