## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-13 - Integer overflow prevention in interactive prompts
**Vulnerability:** Input validation using regex `^[0-9]+$` on interactive prompts combined with `as.integer()` allows inputs larger than R's max integer (e.g., `999999999999999999999`) to cause `NA` coercion via integer overflow. This missing value can crash execution when evaluated in an `if()` condition (e.g., `if (confirm != 1)`).
**Learning:** `grepl("^[0-9]+$")` only checks if characters are digits, but does not enforce bounds checking for the data type it's subsequently parsed into.
**Prevention:** Strictly validate inputs from `readline()` against specific expected discrete values (e.g., `if (n == "1" || n == "2")`) to explicitly reject any out-of-bounds or malformed entries prior to type coercion.
