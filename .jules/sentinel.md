## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2026-09-22 - [readline() 입력에 대한 정수 변환 오버플로우 DoS 위험 해결]
**Vulnerability:** 사용자로부터 `readline()`을 통해 입력을 받을 때, `grepl("^[0-9]+$", n)`과 같이 정규식으로 숫자 여부만 검증한 뒤 `as.integer()`로 변환하면, 사용자가 매우 큰 숫자를 입력할 경우 정수 오버플로우로 인해 `NA`가 반환되어 후속 로직에서 에러(DoS)가 발생할 수 있습니다.
**Learning:** 입력값 검증 시 데이터의 타입뿐만 아니라 길이와 도메인(가능한 값의 집합)도 함께 검증해야 합니다. 특히 R에서 정수형 변환 시 발생할 수 있는 오버플로우를 주의해야 합니다.
**Prevention:** `n %in% c("1", "2")`와 같이 정확하게 허용 가능한 값만 통과시키는 엄격한 화이트리스트 검증(Strict Exact-Match Validation)을 사용합니다.