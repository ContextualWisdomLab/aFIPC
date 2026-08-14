## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-14 - 정수 오버플로우 방지를 위한 readline 입력값 검증 강화
**Vulnerability:** `R/aFIPC.R` 내에서 사용자 입력을 받을 때 정규식 `^[0-9]+$`를 사용해 매우 큰 숫자 입력 시 오버플로우가 발생, `as.integer()`에서 `NA`를 반환해 후속 처리에 에러를 야기할 수 있음 (integer overflow coercion vulnerability).
**Learning:** `readline()`과 같은 상호작용 입력의 경우 단순한 숫자 문자 클래스(`[0-9]+`)보다 입력받을 값의 범위를 명확히 제한하는 것이 중요함.
**Prevention:** 향후 입력값을 검증할 때 허용되는 정확한 값(예: `^[12]$`)에 대해서만 매칭하도록 정규식을 작성해야 함.
