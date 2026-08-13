## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-13 - 정수 오버플로우 DoS 취약점 수정
**Vulnerability:** 대화형 `readline()` 입력 검증 시 무제한 숫자 매칭(`^[0-9]+$`)을 사용하면 지나치게 큰 숫자가 입력될 경우 `as.integer()`에서 `NA`를 반환하여 프로세스 크래시를 유발할 수 있습니다.
**Learning:** 입력 검증 시 기대되는 정확한 값(예: `^[12]$`)과 엄격하게 일치시켜야 합니다.
**Prevention:** 대화형 숫자 입력 검증 시 기대되는 값의 범위에 맞는 엄격한 정규 표현식을 사용하십시오.
