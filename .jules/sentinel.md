## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-08-23 - [입력값 검증 시 정규식 범위 초과 취약점(Integer Overflow) 수정]
**Vulnerability:** 대화형 프롬프트(예: `readline`) 입력값을 검증할 때 `^[0-9]+$`와 같이 경계가 없는 숫자 정규식을 사용하면, 사용자가 매우 큰 숫자를 입력하여 검증을 통과한 후 `as.integer()`에서 `NA`로 강제 변환되어 후속 로직에서 예외가 발생할 수 있습니다.
**Learning:** R에서 정수를 처리할 때 무제한 길이를 허용하는 정규식은 타입 변환 중 integer overflow 문제를 유발하여 시스템 장애나 예상치 못한 에러를 발생시킬 수 있습니다.
**Prevention:** 대화형 입력 등 제한된 선택지를 가진 값을 검증할 때는 `^[12]$`와 같이 기댓값과 정확히 일치하는 엄격한 정규식을 사용하여 입력값을 제한해야 합니다.
