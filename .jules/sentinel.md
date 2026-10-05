## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-10-05 - Fix unbounded integer conversion integer overflow DoS vulnerability
**Vulnerability:** In R, taking inputs using unbounded regex validation like `grepl("^[0-9]+$", n)` followed by `as.integer(n)` for readline inputs can lead to integer overflow and `NA` coercions if the input is extremely large, crashing conditional logic.
**Learning:** `grepl("^[0-9]+$", n)` allows infinitely large numbers which `as.integer` cannot handle without creating an `NA`, skipping safe limits.
**Prevention:** Rather than using unbounded regex for simple integer inputs intended to be `1` or `2`, check against explicitly string-formatted options `n == "1" || n == "2"`.
