## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-24 - [정수 오버플로우 방지를 위한 입력값 검증 강화]
**Vulnerability:** 대화형 프롬프트 입력(`readline()`)을 검증할 때 `grepl("^[0-9]+$", n)`과 같은 정규표현식만 사용하면, 매우 큰 숫자 문자열이 정규표현식을 통과한 후 `as.integer()`로 변환될 때 정수 오버플로우를 일으켜 `NA`를 반환하게 되며, 이로 인해 애플리케이션 크래시(DoS)가 발생할 수 있음.
**Learning:** 숫자 문자열 검증 시 허용 가능한 범위를 명시적으로 확인하지 않고 단순 형태학적 검증(정규표현식)에 의존하면 예기치 못한 타입 변환 문제가 발생할 수 있다는 것을 알게 됨.
**Prevention:** 사전에 정의된 옵션 세트 내의 값인지 확인하는 엄격한 일치 검증(예: `n %in% c("1", "2")`)을 사용하여 입력값을 제한하고 안전하게 처리해야 함.
