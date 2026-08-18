## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-25 - Fix weak regex validation causing integer overflow DoS
**Vulnerability:** Weak regex `^[0-9]+$` allows arbitrarily large numeric strings that coerce to `NA` when cast to integer, causing crash/DoS when passed to `if()`.
**Learning:** When reading bounded numeric options via `readline()` in R, avoid weak numeric regex as large inputs will overflow native integer coercion, breaking unhandled boolean contexts.
**Prevention:** Use strictly bounded exact-match regex like `^[12]$` when validating constrained terminal inputs to prevent unexpected `NA` coercions.
