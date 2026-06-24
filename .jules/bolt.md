## $(date +%Y-%m-%d) - [Pre-calculate Theta Variables to Avoid Redundant MAP estimation]
**Learning:** `mirt::fscores(..., method = 'MAP')` is called redundantly multiple times in `R/aFIPC.R`. It's an expensive operation and avoiding duplicate calls by pre-calculating and reusing the variables significantly improves performance.
**Action:** Always pre-calculate and reuse the resulting Theta variables rather than calling it redundantly.
