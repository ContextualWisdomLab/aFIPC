## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-27 - 대화형 프롬프트의 정수 오버플로 취약점 수정
**Vulnerability:** 대화형 `readline()` 숫자 입력에 대해 `^[0-9]+$`와 같이 제한 없는 숫자 클래스를 사용하여 검증할 때, 지나치게 큰 숫자 문자열이 정규식 검사를 통과하지만 `as.integer()`에서 `NA`로 평가되어 이후 프로세스 충돌(정수 오버플로 강제 변환 취약점)을 유발할 수 있습니다.
**Learning:** R에서 대화형 숫자 입력을 검증할 때, 제한 없는 숫자 범위보다는 예상되는 정확한 값(예: `^[12]$`)과 일치시켜야 합니다.
**Prevention:** 향후 입력 검증 로직에서는 항상 제한된 길이와 정확한 범위를 확인하도록 정규식을 작성해야 합니다.
