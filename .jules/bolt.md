## 2026-06-25 - [Optimize redundant fscores calls in autoFIPC]
**Learning:** In the `aFIPC` package, `mirt::fscores(..., method = 'MAP')` is an expensive operation. Redundant calls inside `autoFIPC` for `Theta` calculations slow down the algorithm significantly. Pre-calculating `ThetaOldform`, `ThetaLinkedform`, and `ThetaNewform` and passing them to `mirt::expected.test(..., Theta = ...)` avoids recomputing them.
**Action:** Always pre-calculate and reuse the resulting Theta variables rather than calling `fscores` redundantly to improve performance in mirt operations.
