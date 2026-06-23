## 2024-10-24 - [Avoid Redundant MAP Estimations in aFIPC.R]
**Learning:** The `fscores()` function for MAP estimation is an expensive operation in `mirt`. In `R/aFIPC.R`, these were being calculated twice consecutively: once inline for `mirt::expected.test()` and once immediately after for assignment to output variables.
**Action:** When calculating expected scores using MAP thetas, always pre-calculate the thetas and reuse the variables rather than calling `fscores()` multiple times.
