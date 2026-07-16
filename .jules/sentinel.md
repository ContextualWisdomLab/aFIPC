## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-16 - Fix weak regex validation in readline inputs
**Vulnerability:** Weak regex `^[0-9]+$` on interactive inputs allowed arbitrarily large integers which R coerces to `NA` when converting via `as.integer()`.
**Learning:** This `NA` coercion in subsequent `if` condition checks causes Unhandled Exception crashes and constitutes a Denial of Service (DoS) vulnerability. Bounded exact-match regex like `^[12]$` must be used for limited choices.
**Prevention:** Always use bounded exact-match regex validations when accepting user inputs intended for exact menu choices.
