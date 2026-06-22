## 2024-05-24 - Subsetting DataFrames for Metadata
**Learning:** Legacy codebase used expensive dataframe subsetting (`newformXDataK[colnames(newFormModel@Data$data)]`) just to extract the column names (`colnames(...)`) or column count (`ncol(...)`). This creates an unnecessary memory copy of a potentially large dataframe merely to get its metadata.
**Action:** When extracting metadata (like dimensions or names), always extract directly from the source structure rather than subsetting it first.
