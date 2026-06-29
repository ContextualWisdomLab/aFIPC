## 2024-06-28 - [Cache fscores theta calculations]
**Learning:** `mirt::fscores(..., method = 'MAP')` is an expensive calculation that was being called redundantly to supply theta estimates to `mirt::expected.test(...)` and then separately to assign to standard result lists (`ThetaOldform`, `ThetaLinkedform`, `ThetaNewform`).
**Action:** Always compute and cache theta variables from `mirt::fscores(...)` prior to using them in expected score generation or assigning them to a payload structure.
