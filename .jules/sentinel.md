## 2023-10-04 - Fix integer overflow DoS vulnerability in readline input validation
**Vulnerability:** Interactive `readline()` prompts validated input using `grepl('^[0-9]+$', n)` which allowed arbitrarily long numeric strings. Converting these with `as.integer()` caused an integer overflow, producing NAs and crashing the subsequent logic.
**Learning:** Using broad regex constraints like `^[0-9]+$` on interactive inputs exposes R programs to integer overflow errors.
**Prevention:** Always use strict exact matching (e.g., `n %in% c('1', '2')`) for predefined option sets.
