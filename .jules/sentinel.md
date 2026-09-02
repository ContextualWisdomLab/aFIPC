## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-11-20 - 입력값 검증 강화를 통한 정수 오버플로 방지
**Vulnerability:** 대화형 프롬프트의 `readline()` 입력 처리 시 `^[0-9]+$`와 같은 광범위한 정규식을 사용하면 큰 숫자가 들어왔을 때 `as.integer()`에서 `NA`를 반환하게 되어 후속 프로세스에 오류를 유발할 수 있습니다 (Integer overflow coercion).
**Learning:** R 스크립트에서 상호작용 방식의 `readline()` 숫자 입력 유효성 검사에서는 예상되는 정확한 값(예: `^[12]$`)을 일치시켜야 합니다.
**Prevention:** 광범위한 숫자 클래스 정규식보다, 가능한 정확한 값과 형식을 제한하여 입력을 검증하여 정수 오버플로 및 의도치 않은 형변환 취약점을 방지해야 합니다.
