## 2026-07-05 - Cached Array Index Lookups and Avoided Redundant String Concatenation
**Learning:** Repeatedly calling `which()` for array index scanning in a loop is an O(N) operation that causes unnecessary overhead in R. Wrapping single scalar strings in `paste0()` is an anti-pattern that slows down text processing marginally.
**Action:** Always cache the result of `which()` into a variable if it's used more than once for identical index retrieval. Avoid redundant `paste0()` for single strings.
