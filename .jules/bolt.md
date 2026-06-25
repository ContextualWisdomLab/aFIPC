## 2024-06-25 - Avoid grep and as.factor in loops

**Learning:** `length(levels(as.factor(x)))` is much slower compared to `length(unique(x))`. Furthermore, doing `length(grep('^name$', colnames(...))) == 1` inside a loop over a large number of common items is slower than pre-filtering columns and using the `%in%` operator.

**Action:** Replace `as.factor()` with `unique()` and replace `grep` on column names with `%in%` when checking for variable names inside loops in `autoFIPC`.
