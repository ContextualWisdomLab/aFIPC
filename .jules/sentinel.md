## 2024-07-17 - Weak Regex Validation Coercion DoS
**Vulnerability:** Weak regex `^[0-9]+$` used to validate integer input allows excessively large numbers to be entered. When parsed by `as.integer()`, they are coerced to `NA`, bypassing validation and causing runtime crashes or infinite loops when used in `if` conditions.
**Learning:** The legacy implementation used greedy validation that didn't consider the maximum bounds of `integer` types in R, relying blindly on base numeric characters rather than specific valid options.
**Prevention:** Use strictly bounded exact-match regex (like `^[12]$`) for discrete choice options to prevent `NA` coercion and subsequent Denial of Service risks.
