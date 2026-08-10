## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-10 - Fix weak regex validation in readline causing Denial of Service via integer coercion
**Vulnerability:** Weak regex `^[0-9]+$` on interactive prompts allowed unconstrained large inputs. When coerced with `as.integer()`, these inputs become `NA`, bypassing conditional structures and potentially causing unhandled exceptions or DoS.
**Learning:** R handles large integers by replacing them with `NA` (with a warning) rather than a max value, breaking logical loops relying on `==` or `!=`.
**Prevention:** Use strictly bounded regular expressions (e.g., `^[12]$`) when asking for specific enumeration inputs to avoid coercion crashes entirely.
