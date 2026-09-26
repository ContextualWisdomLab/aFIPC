# 변경 사항

## [Unreleased]
- ⚡ Bolt: `aFIPC.R` 내부에서 항목 수 탐색 시 `length(stats::na.omit())`을 `sum(!is.na())`로 변경하여 S3 메서드 디스패치 및 속성 할당 오버헤드를 최적화하였습니다.
