# Changelog

## [Unreleased]
### 성능 개선 (Performance)
- `R/aFIPC.R` 내 공통 문항명 추출 과정을 `for` 루프에서 `as.character(unlist(...))` 벡터 연산으로 변경하여 실행 속도를 최적화했습니다. (⚡ Bolt)
