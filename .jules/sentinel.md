## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-09-12 - [DoS 취약점 방지를 위한 대화형 입력 검증 강화]
**Vulnerability:** `readline()` 입력 시 `grepl("^[0-9]+$", n)` 정규식에 매우 큰 숫자가 통과할 경우, `as.integer()` 변환에서 정수 오버플로우가 발생해 `NA`를 반환하여 DoS(애플리케이션 충돌)를 유발할 수 있습니다.
**Learning:** 숫자 입력에 대한 정규식 검사만으로는 정수형 변환의 오버플로우 취약점을 방어하기 어렵다는 점을 배웠습니다.
**Prevention:** 정규식 기반 검사 대신, `n %in% c("1", "2")`와 같은 사전 정의된 옵션 세트를 사용하는 엄격한 정확한 일치(Exact-match) 검증을 사용해야 합니다.
