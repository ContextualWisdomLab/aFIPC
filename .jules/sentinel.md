## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-08-24 - [입력 유효성 검사 강화: 정수 오버플로우 방지]
**Vulnerability:** readline() 수치형 입력값에 대해 단순 숫자 허용 정규표현식(^[0-9]+$)을 사용하여, 지나치게 큰 숫자가 입력될 경우 as.integer() 변환 시 NA가 반환되어 프로세스 크래시 등 예기치 않은 오류가 발생할 수 있습니다.
**Learning:** 사용자 입력은 정확히 예상되는 값(^[12]$)만을 엄격하게 매칭하여 정수 오버플로우 강제 변환(integer overflow coercion) 취약점을 예방해야 함을 배웠습니다.
**Prevention:** 인터랙티브 입력(readline 등) 검증 시 무한정 반복되는 숫자 클래스(^[0-9]+$)를 피하고, 항상 정확하게 일치하는 값만 허용하는 정규표현식을 사용해야 합니다.
