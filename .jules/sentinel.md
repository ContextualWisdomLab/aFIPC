## 2026-07-21 - Fix integer overflow coercion vulnerabilities in interactive prompts

**Vulnerability:** Interactive prompts using `readline()` validated numeric inputs with `^[0-9]+$`, which allowed excessively large numeric strings to pass the regex check but evaluate to `NA` when coerced with `as.integer()`. This unhandled `NA` would cause process crashes when used in conditional statements.
**Learning:** In R, unbounded numeric regex validation (`^[0-9]+$`) coupled with `as.integer()` coercion is insufficient for exact matching and can lead to unhandled integer overflow exceptions.
**Prevention:** Strictly match interactive numeric inputs against exact expected values (e.g., `^[12]$`) instead of unbounded digit classes to prevent both unexpected values and integer overflow coercion vulnerabilities.
