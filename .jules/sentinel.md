## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-11 - 대화형 R 프롬프트 입력값 검증 강화
**Vulnerability:** 대화형 프롬프트(`readline()`)의 입력값을 `grepl("^[0-9]+$", n)`과 같이 검증하면 과도하게 큰 숫자가 입력될 경우 `as.integer()` 과정에서 정수 오버플로우가 발생하여 `NA`로 변환되고 프로세스가 충돌할 수 있는 취약점이 있습니다.
**Learning:** R 스크립트에서 입력값을 받을 때는 예상되는 정확한 값만 받도록 정규표현식을 엄격하게 제한해야 합니다.
**Prevention:** `readline()`을 통한 숫자 입력을 검증할 때 단순한 숫자 패턴(`^[0-9]+$`) 대신 예상되는 값과 정확히 일치하는 패턴(예: `^[12]$`)을 사용하여 정수 오버플로우 강제 변환 취약점을 방지해야 합니다.
