## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-26 - Fix interactive input integer overflow coercion
**Vulnerability:** Interactive `readline()` prompts previously used unbounded digit matching (`^[0-9]+$`), which allowed users to input extremely large numeric strings that would pass the regex check but result in an `NA` evaluation when passed to `as.integer()`. This can lead to unexpected type coercion issues or application crashes.
**Learning:** For interactive command-line interfaces using `readline()`, strictly bounding the expected input (e.g., `^[12]$`) prevents integer overflow coercion vulnerabilities.
**Prevention:** Use strictly defined regex boundaries for expected options instead of arbitrary length numeric classes when asking for categorical numeric input via `readline()`.
