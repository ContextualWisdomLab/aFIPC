## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-08-10 - [Integer Overflow Coercion Vulnerability 수정]
**Vulnerability:** `readline()` 입력값 검증 시 `^[0-9]+$` 정규표현식을 사용하여 숫자형 문자열을 검증하고 `as.integer()`로 변환하는 과정에서, 지나치게 큰 숫자가 입력되면 R에서 정수 범위를 초과하여 `NA`를 반환하는 오버플로우 강제 변환(coercion) 취약점이 발견되었습니다.
**Learning:** `^[0-9]+$`는 자릿수 제한이 없기 때문에 의도하지 않은 큰 수가 입력될 수 있으며, 이 값이 정수로 변환될 때 `NA`가 되어 이후의 로직(예: 프로세스 크래시)에 치명적인 영향을 미칠 수 있습니다.
**Prevention:** 1과 2 같은 제한적인 선택지를 요구할 때는 정확히 일치하는 범위만 허용하도록 `^[12]$` 와 같이 엄격한 정규표현식을 적용해야 합니다.
