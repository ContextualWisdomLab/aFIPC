## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-06 - [R 언어에서 readline 입력의 정수 오버플로우 변환(Integer Overflow Coercion) 및 유효성 검사 취약점 수정]
**Vulnerability:** `readline()`으로 사용자 입력을 받을 때, `grepl("^[0-9]+$", n)`만을 사용하여 숫자 형태인지만 검증한 후 `as.integer(n)`를 호출하면, R의 32비트 정수 한계(약 21억)를 넘는 매우 큰 숫자 문자열(예: `99999999999`)이 입력될 경우 정수 오버플로우가 발생하여 강제로 `NA`가 반환되는 취약점(정수 변환 손실/오류)이 존재했습니다. 이는 후속 로직에서 예기치 않은 동작이나 충돌을 유발할 수 있는 보안 결함입니다.
**Learning:** 정규표현식 `^[0-9]+$`는 숫자 문자로만 이루어져 있다는 것은 보장하지만, 해당 숫자가 시스템 정수 범위 내에 속하는지는 보장하지 못합니다. 제한된 선택지(예: "1" 또는 "2")를 입력받아야 하는 상황에서 너무 포괄적인 정규표현식을 사용하는 것은 입력 유효성 검사 관점에서 불충분하며, 입력값의 길이 및 정수 변환 시의 안전성을 함께 고려해야 함을 확인했습니다.
**Prevention:** 사용자 입력을 특정 선택지로 제한할 경우 포괄적인 정규표현식 대신 `if (n %in% c("1", "2"))`와 같이 화이트리스트 기반의 명시적 값 비교(Exact string matching)를 수행하여 입력 범위를 강제하고 정수 오버플로우 발생 원인을 근본적으로 차단해야 합니다.
