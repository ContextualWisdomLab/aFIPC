## 2024-06-26 - [Pre-calculating MAP Theta in autoFIPC]
**Learning:** MAP Theta estimation with `mirt::fscores(..., method = 'MAP')` is an expensive operation in `aFIPC.R`. The current code calculates it twice per form (once for `expected.test` and once for saving to `Theta...`).
**Action:** Always pre-calculate and reuse the resulting Theta variables rather than calling it redundantly to improve performance.
