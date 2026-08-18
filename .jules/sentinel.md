## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-08-18 - 대화형 입력값 검증 시 정수 오버플로우 방지
**Vulnerability:** 대화형 `readline()` 입력을 검증할 때 경계가 없는 숫자 정규식(`^[0-9]+$`)을 사용하면, 악의적으로 큰 숫자가 입력될 경우 `as.integer()`에서 `NA`로 강제 변환되어 이후 프로세스에서 예상치 못한 오류나 중단(Denial of Service)이 발생할 수 있습니다.
**Learning:** 숫자 입력 검증 시에는 허용되는 정확한 값(예: `^[12]$`)만 매칭되도록 정규표현식을 제한하여 정수 오버플로우로 인한 취약점을 방지해야 합니다.
**Prevention:** `readline()`과 같은 함수로 입력값을 받을 때는 허용된 범위의 정확한 값을 매칭하는 정규식을 사용하여 입력 검증을 엄격하게 수행합니다.
