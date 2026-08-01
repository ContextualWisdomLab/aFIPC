## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-01 - Fix Integer Overflow Coercion Vulnerability
**Vulnerability:** Unbounded numeric regular expressions (`^[0-9]+$`) were used to validate interactive inputs before coercing them to integer using `as.integer()`. If excessively large numbers were provided, they would pass the regex check but coercion would produce `NA`, which could cause unexpected downstream failures or crashes.
**Learning:** In R scripts, validating inputs using `^[0-9]+$` does not account for the limits of R's integer representation. This can lead to integer overflow coercion vulnerabilities.
**Prevention:** Strictly match against exact expected values (e.g., `^[12]$`) instead of unbounded digit classes to ensure the input fits safely within R's integer bounds.

## 2026-08-01 - Avoid committing tarball files downloaded during CI scripts
**Vulnerability:** Inadvertently committing `.tar.gz` and extracted binaries (like `actionlint` or `gitleaks`) into the repository.
**Learning:** During test runs or script execution, tools might be downloaded into the root directory. If the tree isn't cleaned up (or if they are not explicitly gitignored), they can accidentally be committed via blind `git commit -a` or tracked if created locally.
**Prevention:** Avoid explicitly `git add`ing them. Also, use temporary directories to download binaries instead of the repo root or make sure to delete them after use.
