## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-18 - [CRITICAL] 대화형 입력의 정수 오버플로 취약점 수정
**Vulnerability:** `readline()` 입력 처리 시 `^[0-9]+$` 정규식을 사용하여 무제한 자릿수의 숫자 문자열을 허용함. 이로 인해 과도하게 큰 숫자가 입력될 경우 `as.integer()`에서 `NA`로 평가되어 후속 프로세스 크래시를 유발함.
**Learning:** 정수형 입력값 검증 시 길이 제한이나 정확한 값 매칭 없이 범용적인 숫자 클래스(`[0-9]`)를 반복 매칭할 경우 예상치 못한 타입 강제 변환(coercion) 취약점이 발생할 수 있음을 확인.
**Prevention:** 인터랙티브 입력에서 1 또는 2와 같은 특정 선택지만 허용해야 하는 경우, 무제한 자릿수를 허용하는 `^[0-9]+$` 대신 정확한 기대 값 목록에만 매칭되는 `^[12]$` 정규식을 사용해야 함.
