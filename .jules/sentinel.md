## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-31 - 대화형 입력의 정수 오버플로 취약점 수정
**Vulnerability:** 대화형 `readline()` 입력을 검증할 때 `^[0-9]+$` 정규식을 사용하여, 매우 큰 숫자가 입력될 경우 `as.integer()` 변환 시 정수 오버플로가 발생하여 `NA`가 반환되는 취약점.
**Learning:** `^[0-9]+$` 정규식은 너무 광범위하여 입력 가능한 모든 숫자를 통과시키기 때문에 발생함. 기대되는 값(예: 1 또는 2)만을 명확하게 제한하지 않아서, 오버플로된 큰 숫자가 통과하고 후속 `as.integer()`에서 `NA`가 되어 이후의 조건문(`if (confirm != 1)`) 등에서 예기치 않은 오류나 프로세스 중단을 유발할 수 있음.
**Prevention:** 대화형 프롬프트의 숫자 입력값을 검증할 때는 광범위한 숫자 클래스 정규식 대신 기대하는 정확한 값(예: `^[12]$`)만을 허용하도록 제한하여 오버플로 및 예기치 않은 값의 강제 변환(coercion) 취약점을 방지해야 함.
