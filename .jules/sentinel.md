## 2024-05-22 - Avoid reading sensitive data with stringsAsFactors = TRUE
**Learning:** In older versions of R (prior to 4.0.0), `read.table` and `read.csv` default to `stringsAsFactors = TRUE`. This can cause sensitive text data to be automatically converted to factors, exposing all unique values in memory when inspecting the structure or summary.
**Action:** Always set `stringsAsFactors = FALSE` explicitly when reading data, or use modern alternatives like `readr::read_csv` or `data.table::fread` which do not convert strings to factors by default.
