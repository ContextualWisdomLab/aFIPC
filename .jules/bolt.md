## 2026-06-30 - Pre-calculate Theta Variables to Avoid Redundant MAP estimation
**Learning:** `mirt::fscores(..., method = 'MAP')` is called redundantly multiple times in `R/aFIPC.R`. It's an expensive operation and avoiding duplicate calls by pre-calculating and reusing the variables significantly improves performance.
**Action:** Always pre-calculate and reuse the resulting Theta variables rather than calling it redundantly.

## 2026-06-30 - Preserve numerical output when caching MAP scores
**Learning:** `fscores(..., method = 'MAP')` caching is safe only when the cached theta values are passed to the same downstream `expected.test()` calls without changing model state or estimation options.
**Action:** Treat MAP-score caching as a pure reuse optimization and keep true-parameter recovery tests in place when changing calibration code.

## 2024-05-18 - R 언어에서 루프 내 정규식 탐색 병목 최적화
**Learning:** R에서 데이터 프레임의 크기가 커질수록 루프 내에서 컬럼명을 추출하고 정규식을 이용해(`grep`) 문자열을 탐색하는 작업이 상당한 성능 오버헤드를 발생시킨다. 특히 O(N) 탐색을 루프 안에서 반복할 경우 O(N^2)의 비효율성을 초래한다.
**Action:** 루프 내부에서 자주 호출되는 컬럼명이나 데이터 프레임 구조 탐색을 루프 밖으로 빼서 한 번만 계산하여 벡터로 저장하도록 한다. 정규식보다는 완전 일치 탐색(`%in%`, `match`)이 가능하도록 벡터 연산을 활용해 O(1) 수준으로 성능을 끌어올려야 한다.

## 2026-06-30 - Keep paired form item names when removing grep
**Learning:** Replacing regex lookups with direct name references must still respect that the same common item can have different column names in the new and old forms.
**Action:** Resolve names independently with each form's declared common-item vector before subsetting model data.

## 2026-06-30 - Avoid factor allocation for response-category counts
**Learning:** `levels(as.factor(x))` allocates a factor just to count response categories, which is unnecessary in repeated common-item loops.
**Action:** Use `length(na.omit(unique(x)))` for category-count comparisons while preserving the existing exact item-name matching.

## 2026-06-30 - Preserve NA handling when removing factor conversions
**Learning:** `levels(as.factor(x))` excludes missing responses from the category count, so a faster replacement must not count `NA` as an extra response category.
**Action:** Keep `na.omit(unique(x))` rather than plain `unique(x)` in response-category comparisons.

## 2026-06-30 - Cache vector-search indexes in R loops
**Learning:** Redundant `which()` array scans inside loops introduce unnecessary O(N) overhead during array subsetting, especially when accessing the exact same index multiple times within the loop body. In this codebase's common item loop, repeated `which(NewScaleParms$item == ...)` calls were a bottleneck.
**Action:** Cache the resulting index into a variable (e.g. `idx <- which(...)`) at the start of the relevant block and reuse it for all subsequent operations to avoid repeated O(N) penalty.
