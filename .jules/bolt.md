## 2024-07-25 - Prevent redundant expensive operations (mirt::fscores)
**Learning:** In the `aFIPC` package, calculating `mirt::fscores(..., method = 'MAP')` is an expensive operation. Previously, it was called redundantly: once to calculate expected scores (`mirt::expected.test`) and once again to return the `Theta` variables.
**Action:** Always pre-calculate expensive operations like `fscores` and store them in variables to reuse them, avoiding redundant CPU cycles.
