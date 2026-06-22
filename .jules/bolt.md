## 2024-06-21 - [Pattern of repetitive `grep` calls inside loops in R]
**Learning:** In `aFIPC.R` (e.g. lines 549-570 and 695-720), there is a pattern of iterating over item names and using `grep` multiple times per iteration to find columns in `newformXDataK` and `oldformYDataK`. This is computationally expensive, especially inside loops, when standard column matching like `%in%` or direct matching could be utilized or when the `grep` could be done once outside the loop if required. However, considering the potential complexity of those conditional matching and to keep "changes minimal and auditable" (as requested by AGENTS.md), the vectorization loop removal is the safest, cleanest small win that directly eliminates an unnecessary loop.
**Action:** Replaced the `ActualoldFormCommonItem` allocation loop with a vectorized approach in R.

## 2024-05-24 - Subsetting DataFrames for Metadata
**Learning:** Legacy codebase used expensive dataframe subsetting (`newformXDataK[colnames(newFormModel@Data$data)]`) just to extract the column names (`colnames(...)`) or column count (`ncol(...)`). This creates an unnecessary memory copy of a potentially large dataframe merely to get its metadata.
**Action:** When extracting metadata (like dimensions or names), always extract directly from the source structure rather than subsetting it first.
