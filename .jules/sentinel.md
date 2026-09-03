## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-05-18 - [입력값 검증 시 정수 오버플로우 방지]
**Vulnerability:** 대화형 프롬프트(`readline()`)의 숫자 입력 검증 시 제한 없는 정규식(`^[0-9]+$`)을 사용하여 매우 큰 수가 입력될 경우 `as.integer()`에서 `NA`로 평가되는 정수 오버플로우 취약점이 있었습니다.
**Learning:** 기대하는 입력값이 한정적일 때 광범위한 숫자 클래스 패턴 일치를 허용하면 다운스트림 함수(예: 변환 함수)에서 예기치 않은 동작이나 충돌을 유발할 수 있음을 확인했습니다.
**Prevention:** 대화형 프롬프트나 폼 검증 시에는 예상되는 값을 정확히 매칭하는 엄격한 정규식(예: `^[12]$`)을 사용하여 허용 범위를 명확히 제한해야 합니다.
