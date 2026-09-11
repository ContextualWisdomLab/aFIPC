## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-11 - 정수 오버플로우 검증 취약점 해결
**Vulnerability:** readline()으로 입력받은 값을 grepl("^[0-9]+$", n)과 같은 정규식으로만 검증한 후 as.integer()로 변환하면, 매우 큰 숫자가 입력될 경우 정수 오버플로우로 인해 NA가 반환되며, 이를 논리 연산에 사용할 경우 애플리케이션 크래시(DoS)가 발생할 수 있습니다.
**Learning:** 숫자형 문자열을 정수형으로 변환하기 전에는 단순 정규식이 아닌 사전에 정의된 정확한 옵션 값(예: "1", "2")과의 일치 여부를 확인하는 것이 안전합니다.
**Prevention:** 대화형 프롬프트에서 제한된 옵션을 입력받을 때는 n %in% c("1", "2")와 같은 엄격한 완전 일치 검증을 사용해야 합니다.
