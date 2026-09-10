## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-10 - [Readline 입력 검증 취약점 수정]
**Vulnerability:** `readline()`으로 사용자 입력을 받을 때 `grepl("^[0-9]+$", n)`과 같이 정규식으로만 검증하면 지나치게 큰 숫자가 입력될 경우 정수형(integer)으로 변환 시 오버플로우가 발생하여 `NA`가 반환되며, 이를 논리문에 사용할 경우 애플리케이션 충돌(DoS)을 유발할 수 있습니다.
**Learning:** R에서 사용자 입력값을 `as.integer()`로 변환하여 제한된 옵션 중 하나로 검증할 때는 정규식 대신 정확한 문자열 일치(예: `n %in% c("1", "2")`)를 사용해야 정수 오버플로우로 인한 크래시를 방지할 수 있습니다.
**Prevention:** 사전에 정의된 선택지 중 하나를 입력받을 때는 항상 `%in%` 연산자를 활용한 엄격한 일치 검증을 수행합니다.
