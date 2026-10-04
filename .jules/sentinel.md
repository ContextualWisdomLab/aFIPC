## 2026-10-04 - Fix integer overflow in interactive prompt validation
**Vulnerability:** The interactive validations used unbounded regex `grepl("^[0-9]+$", ...)` followed by `as.integer()`. This allowed integer overflow (coercion to `NA`) when very large strings of numbers were supplied, crashing the downstream check `if (confirm != 1)`.
**Learning:** In R, unbounded numeric string evaluations for simple discrete choices can trigger integer overflows and bypass intended logic flows, acting as a subtle vector for uncontrolled crashes or logic bypasses in interactive scripts.
**Prevention:** Always validate interactive inputs intended for small integer menus against the specific expected string choices (e.g., `n == "1" || n == "2"`) rather than attempting unbounded numeric regex validation.

## 2026-10-04 - Fix integer overflow in interactive prompt validation
**Vulnerability:** The interactive validations used unbounded regex `grepl("^[0-9]+$", ...)` followed by `as.integer()`. This allowed integer overflow (coercion to `NA`) when very large strings of numbers were supplied, crashing the downstream check `if (confirm != 1)`.
**Learning:** In R, unbounded numeric string evaluations for simple discrete choices can trigger integer overflows and bypass intended logic flows, acting as a subtle vector for uncontrolled crashes or logic bypasses in interactive scripts.
**Prevention:** Always validate interactive inputs intended for small integer menus against the specific expected string choices (e.g., `n == "1" || n == "2"`) rather than attempting unbounded numeric regex validation.
