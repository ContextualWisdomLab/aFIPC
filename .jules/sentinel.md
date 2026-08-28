## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-28 - 정수 오버플로우 취약점 및 readline 유효성 검사 수정
**Vulnerability:** 대화형 `readline()` 숫자 입력 시 상한 없는 숫자 클래스(예: `^[0-9]+$`)에 대해 정규식 확인을 통과한 지나치게 큰 숫자 문자열이 `as.integer()`에서 `NA`로 평가되어 후속 프로세스 충돌을 유발하는 정수 오버플로우 강제 변환 취약점이 발생할 수 있습니다.
**Learning:** R 스크립트에서 입력값을 검증할 때는 넓은 범위의 정규식보다 정확한 예상 값과 엄격하게 일치시키는 것이 안전합니다.
**Prevention:** 대화형 `readline()` 숫자 입력을 검증할 때, `^[0-9]+$`와 같은 상한 없는 숫자 클래스 대신 `^[12]$`처럼 정확히 기대하는 값과 엄격하게 일치하는지 확인해야 합니다.
