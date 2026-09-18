## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2023-10-25 - [입력값 검증 취약점 수정]
**Vulnerability:** `readline()`으로 받은 입력을 정수로 변환할 때 단순 정규식(`grepl("^[0-9]+$", n)`)만 사용하여, 매우 큰 숫자가 입력될 경우 오버플로우로 인해 `NA`가 반환되어 시스템 충돌(DoS)을 유발할 수 있음.
**Learning:** 단순 패턴 매칭은 타입 변환의 안전성을 보장하지 않음. R에서는 특히 `as.integer()` 변환 시 범위를 초과하면 `NA`로 강제 변환되므로 로직 오류의 원인이 됨.
**Prevention:** 사전에 정의된 유효한 옵션 값들의 집합과 정확히 일치하는지(`%in% c("1", "2")`)를 엄격하게 검증해야 함.
