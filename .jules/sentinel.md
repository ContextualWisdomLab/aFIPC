## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-28 - Fix integer coercion vulnerability from weak regex
**Vulnerability:** Weak regex ^[0-9]+$ allows large integer inputs in readline that coerce to NA, crashing the process in subsequent if conditions.
**Learning:** Coercing large string numbers via as.integer() results in NA. We must strictly bound inputs for interactive prompts to valid options only.
**Prevention:** Use exactly-bounded regex like ^[12]$ when validating prompt options before coercion.
