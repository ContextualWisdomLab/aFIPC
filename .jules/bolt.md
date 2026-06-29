## 2024-06-22 - R Matrix Subsetting Performance
**Learning:** In the `mirt` package, model data slots (e.g. `model@Data$data`) are often stored as matrices, not `data.frame`s. Using `data[[colname]]` on a matrix fails with `subscript out of bounds`. Using `data[, colname]` is correct and prevents runtime crashes.
**Action:** When extracting data for column-level checks (like calculating `length(unique(...))`), use matrix subsetting syntax `[, "colname"]` rather than list subsetting `[["colname"]]` when dealing with internal package slots.

## 2024-06-22 - Replacing `grep` and `as.factor` overhead
**Learning:** Checking for column existence via `length(grep(paste0('^', name, '$'), colnames))` and counting categories via `length(levels(as.factor(col)))` creates major bottlenecks inside iterative loops in R.
**Action:** Replace `grep` operations with straightforward `%in%` matches (`name %in% colnames`). Replace category counts with `length(unique(na.omit(col)))` to skip expensive factor conversions and provide measurable speedups.
