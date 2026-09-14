## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-24 - [대화형 프롬프트의 정수 오버플로 취약점(DoS) 수정]
**Vulnerability:** 대화형 프롬프트에서 `grepl("^[0-9]+$", n)` 정규식을 사용해 입력을 검증한 후 `as.integer()`로 변환할 때, 매우 큰 숫자가 입력되면 R에서 정수 오버플로가 발생하여 `NA`가 반환되고 애플리케이션 크래시가 일어날 수 있습니다.
**Learning:** R에서 사용자 입력(문자열)을 정수로 강제 변환할 때, 단순 정규식 검증은 큰 수에 대한 오버플로를 방어하지 못하며 치명적인 에러로 이어질 수 있습니다.
**Prevention:** 지정된 선택지만 있는 경우, 정규식보다는 `n %in% c("1", "2")`와 같은 정확한 일치 검사를 수행해야 합니다.
