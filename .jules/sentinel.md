## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.


## 2024-05-18 - Insecure regex binding vulnerability in readline input
**취약점:** `aFIPC::autoFIPC()` 내부의 인터랙티브 `readline` 입력 검증에 약한 정규식 `^[0-9]+$` 가 사용됨.
**학습:** `as.integer()`는 `2^31 - 1` 까지만 처리할 수 있으며, 이 범위를 넘는 임의의 긴 숫자열이 입력될 경우 조용히 `NA`를 반환함. 이로 인해 다운스트림 로직이 깨지는 취약점이 발생함.
**방지:** 입력을 정확하게 제한해야 함. 1과 2만 선택받는 프롬프트라면, `^[12]$` 와 같이 엄격한 정규식을 사용하여 입력을 필터링함.
