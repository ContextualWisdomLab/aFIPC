## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-21 - 입력 검증에서 발생할 수 있는 정수 오버플로우 취약점 패치
**Vulnerability:** 대화형 `readline()` 함수에서 `grepl("^[0-9]+$")`와 같이 길이에 제한이 없는 정규표현식을 사용하여 숫자를 검증할 경우, 매우 긴 숫자가 입력되었을 때 `as.integer()` 변환 과정에서 오버플로우가 발생하거나 NA가 반환되어 이후 프로세스에서 크래시가 발생할 수 있습니다.
**Learning:** R 스크립트에서 입력값을 검증할 때는 사용자의 입력이 기대하는 값과 정확히 일치하는지 확인해야 합니다. (예: `^[12]$`)
**Prevention:** `readline()`과 같은 입력을 검증할 때는 가능한 값의 범위나 형태를 정확하게 지정하는 정규표현식을 사용하여 입력 범위를 엄격하게 제한해야 합니다.
