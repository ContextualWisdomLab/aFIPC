## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-18 - [Fix integer overflow in readline validation]
**Vulnerability:** `readline()` 입력을 검증할 때 `^[0-9]+$` 정규식을 사용하여, 사용자가 정수 표현 범위를 초과하는 숫자를 입력하면 `as.integer()`가 `NA`를 반환하는 취약점이 존재했습니다.
**Learning:** 범위가 지정되지 않은 숫자 정규식 매칭은 매우 긴 문자열이 입력되었을 때 정수 강제 형변환(coercion) 시 프로세스가 비정상 종료되는 원인이 될 수 있습니다.
**Prevention:** `readline()`과 같은 상호작용 입력의 경우, 허용되는 정확한 값들(예: `^[12]$`)만 매칭하도록 정규식을 엄격하게 제한해야 합니다.
