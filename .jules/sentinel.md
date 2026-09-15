## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-09-15 - Strict bounds for regex coercions
**Vulnerability:** Loose regex (`^[0-9]+$`) used for validation before coercion allows unexpected inputs (e.g., numbers that exceed machine integer limits like `9999999999999999999`) causing coercion to `NA` when passed to `as.integer()` which leads to missing values where strict integer matches (like 1 or 2) are required.
**Learning:** In interactive CLI menu handlers, weak regular expressions like `^[0-9]+$` pose a security concern because inputs beyond the 32-bit limit silently coerce to `NA` leading to unexpected behaviors downline.
**Prevention:** Always use exact-match regular expressions with tight bounds (e.g., `^[12]$`) when parsing inputs meant to conform to a specific list of single-digit integer choices to prevent silent `NA` coercion vulnerabilities.
