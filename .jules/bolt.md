## 2024-06-28 - Optimize exact string matching in vectors

**Learning:** When performing exact string matching on column names in R, using `grep(paste0('^', name, '$'), colnames)` is significantly slower (almost 20x) than using the `%in%` operator (`name %in% colnames`). Similarly, extracting columns using string matching `df[, grep(..., colnames)]` is less efficient than using direct subsetting `df[, name]`.
**Action:** Always prefer `%in%` for checking column existence and direct string subsetting for dataframes over complex regex-based `grep` matches when exact equality is the goal.
