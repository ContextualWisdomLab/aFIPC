## [Unreleased]
### Security
- 입력 검증 시 정규식을 사용할 때 발생할 수 있는 `as.integer` 강제 변환에 의한 정수 오버플로우 취약점 수정 (interactive 입력값 검증을 `n %in% c("1", "2")`로 변경)
