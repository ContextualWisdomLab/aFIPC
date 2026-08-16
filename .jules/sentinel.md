## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-08-16 - 정수 오버플로우 방지를 위한 입력값 검증 강화
**Vulnerability:** `readline()`을 통한 대화형 사용자 입력 처리 시 `^[0-9]+$` 정규식을 사용하여 입력된 문자열의 크기를 제한하지 않고 숫자로만 구성되어 있는지만 확인하는 취약점이 존재했습니다. 이로 인해 `1` 또는 `2`가 아닌 매우 큰 숫자(예: 12345678901234567890)를 입력할 경우 정규표현식 검증은 통과하지만, 이후 `as.integer()` 호출 시 정수 표현 범위를 초과하여 `NA`로 변환되는 정수 오버플로우 강제 변환 취약점이 발생할 수 있습니다. 이는 결과적으로 예기치 않은 오류나 프로세스 크래시를 유발할 수 있습니다.
**Learning:** R에서 대화형 숫자 입력값을 검증할 때는 정규식(예: `^[0-9]+$`)을 사용하여 단순 숫자 형식만 확인할 것이 아니라, 기대하는 정확한 값(예: `^[12]$`)과 정확히 일치하는지 확인해야 합니다.
**Prevention:** `readline()`과 같이 사용자 입력값을 받아올 때는 입력값이 허용된 정확한 형식이나 값 집합(`^[12]$`)을 엄격하게 준수하는지 항상 검증해야 합니다.
