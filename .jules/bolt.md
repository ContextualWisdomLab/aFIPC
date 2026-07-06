## 2024-07-06 - Replacing multiple grep() with a single !grepl()
**Learning:** Combining multiple negative `grep()` outputs (e.g., `x[-c(grep("A", x), grep("B", x))]`) is inefficient and unsafe in base R. If no patterns match, it evaluates to `x[-integer(0)]` which unexpectedly returns `character(0)`, wiping out the entire vector. Furthermore, multiple `grep` calls are computationally more expensive than a single `grepl`.
**Action:** Always prefer `!grepl("^(A|B|C)", x)` for filtering vectors to improve execution performance and prevent unexpected empty vectors.
