## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-24 - [CRITICAL] Fix integer overflow coercion vulnerability in interactive inputs
**Vulnerability:** Interactive `readline()` prompts for binary choices (1 or 2) used unbounded digit class regex (`^[0-9]+$`). If a user provided an excessively large numeric string, it would pass the validation check but could evaluate to `NA` when passed to `as.integer()`, leading to process crashes downstream.
**Learning:** In R, converting strings representing integers larger than R's `.Machine$integer.max` using `as.integer()` results in `NA` and raises a warning. If this result isn't explicitly handled for `NA` values, it can lead to coercion vulnerabilities and unexpected behaviors.
**Prevention:** When validating numeric strings for known bounded choices (e.g., 1 or 2), strictly match the exact expected values in the regex (e.g., `^[12]$`) instead of simply checking for numeric formats (`^[0-9]+$`).
