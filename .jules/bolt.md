## 2024-06-27 - [Optimization of R Vector Lookups]
**Learning:** Using `grep()` sequentially in a `for` loop to check for the existence of an item in a vector of column names is a significant performance bottleneck in R (`length(grep('^...$', ...)) == 1`), taking ~8000ms for 1000 items. Using the `%in%` operator or fast matching reduces this to ~60ms. In nested logical operations with multiple column name matches, this makes a huge difference.
**Action:** Replace `length(grep(pattern, vector)) == 1` with `%in%` for exact matches in R where applicable.
