## 2024-07-04 - R 언어에서 루프 내 데이터 프레임 탐색 병목 최적화
**Learning:** R에서 루프를 돌면서 매번 데이터 프레임을 서브셋팅(subsetting)하는 작업은 복사 오버헤드로 인해 매우 느려질 수 있습니다. 특히 공통 문항 수가 많아질 경우 O(N^2)의 비효율을 초래합니다.
**Action:** 루프 내에서 수행하던 데이터 프레임 조회를 루프 외부에서 한 번에 `as.character(unlist(...))`로 처리하는 벡터 연산으로 변경하여 타입 변환 없이 O(1) 수준으로 성능을 크게 향상시킬 수 있습니다.
## 2026-07-05 - Cached Array Index Lookups and Avoided Redundant String Concatenation
**Learning:** Repeatedly calling `which()` for array index scanning in a loop is an O(N) operation that causes unnecessary overhead in R. Wrapping single scalar strings in `paste0()` is an anti-pattern that slows down text processing marginally.
**Action:** Always cache the result of `which()` into a variable if it's used more than once for identical index retrieval. Avoid redundant `paste0()` for single strings.
