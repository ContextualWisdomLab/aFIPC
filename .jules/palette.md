## 2024-05-19 - Use logical subsetting instead of na.omit for single variable subsetting
**Learning:** `na.omit` drops all rows if any column in the dataframe has an NA value, which can unintentionally drop valid data when subsetting based on a single variable or vector.
**Action:** Always use logical subsetting like `x[!is.na(x)]` instead of `na.omit(x)` when filtering NAs for a single vector or variable to preserve valid data.
