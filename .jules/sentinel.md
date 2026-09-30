## 2024-10-25 - Prevent DoS from integer overflow in readline
**Vulnerability:** Interactive prompts using `readline()` validated inputs with `grepl("^[0-9]+$", n)`.
**Learning:** Large numeric strings pass this regex but cause integer overflow (returning `NA`) when passed to `as.integer()`, leading to application crashes (DoS risk).
**Prevention:** Use exact-match validation like `n %in% c("1", "2")` for predefined option sets instead of regex checks.
