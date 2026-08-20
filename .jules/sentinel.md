## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-20 - readline 입력값 검증 강화
**Vulnerability:** `readline()`으로 사용자 입력을 받을 때 정규식 `^[0-9]+$`를 사용하면 매우 큰 숫자가 입력될 경우 `as.integer()`에서 `NA`로 변환되어 후속 로직에서 예외가 발생할 수 있습니다.
**Learning:** 대화형 프롬프트의 숫자 입력값 검증 시에는 예상되는 정확한 값(예: `^[12]$`)만 허용해야 합니다.
**Prevention:** `readline()` 반환값을 검증할 때 허용 가능한 값만 정확히 일치하도록 제한된 정규식을 사용하십시오.
