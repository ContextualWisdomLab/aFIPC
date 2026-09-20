## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-20 - [입력값 검증 우회 및 정수 오버플로우 DoS 취약점 수정]
**Vulnerability:** `readline()`으로 받은 입력을 정규식 `^[0-9]+$`으로만 검증한 후 `as.integer()`로 변환할 때, 매우 큰 숫자(예: 10^22)가 입력되면 정수 오버플로우(NA 강제 변환)가 발생하여 프로그램이 비정상 종료(DoS)되는 취약점이 발견되었습니다.
**Learning:** `grepl("^[0-9]+$", n)`과 같은 단순 정규식은 매우 큰 숫자를 허용하며, R에서 `as.integer()`는 범위를 초과하는 숫자에 대해 `NA`를 반환합니다. 조건문에서 `NA`가 평가되면 프로그램이 충돌할 수 있으므로, 제한된 선택지가 있는 대화형 입력의 경우 단순 정규식이 아닌 정확한 값 일치 검증이 필수적입니다.
**Prevention:** 대화형 입력 처리 시 사전에 정의된 유효한 옵션(예: "1", "2")에 대해 엄격한 일치 검사(예: `%in%`)를 수행하여 안전하지 않은 강제 변환과 예상치 못한 런타임 오류를 방지해야 합니다.
