## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-18 - [Fix DoS vector via readline coercion]
**Vulnerability:** `readline()` 입력을 `as.integer()`로 강제 변환하기 전 정규표현식 `grepl("^[0-9]+$", n)`만을 사용하면, 너무 긴 문자열이 정규식을 통과하지만 정수 오버플로우로 인해 `NA`가 반환되어 DoS(서비스 거부) 취약점이 발생할 수 있습니다.
**Learning:** 매우 큰 숫자 문자열은 정규식을 통과할 수 있지만, 이후 로직에서 오류를 유발할 수 있음을 깨달았습니다.
**Prevention:** 미리 정의된 옵션 세트에 대해 `n %in% c("1", "2")`와 같은 엄격한 일치 검증을 사용하여 입력값의 길이나 범위 초과를 방지해야 합니다.
