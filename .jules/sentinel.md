## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-07-25 - 대화형 입력값 검증 강화
**Vulnerability:** `readline()`으로 받은 입력을 `grepl("^[0-9]+$", n)`과 같은 정규식으로만 검증할 경우, 매우 긴 숫자 문자열 입력 시 `as.integer()`에서 정수 오버플로가 발생하여 `NA`가 반환되고 이는 프로세스 크래시(DoS)로 이어질 수 있음.
**Learning:** 제한된 옵션을 갖는 대화형 숫자를 검증할 때는 오버플로우 우회 공격 및 의도치 않은 캐스팅 오류를 방지하기 위해 반드시 완전 일치 검사(예: `n %in% c("1", "2")`)를 사용해야 함.
**Prevention:** 대화형 입력값에 대해 항상 허용된 값들의 집합과 완전 일치하는지 엄격히 검증하도록 함.
