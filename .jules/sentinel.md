## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2026-09-14 - readline() 입력값의 Integer Overflow 취약점 수정
**Vulnerability:** `readline()`에서 숫자 입력 여부를 `grepl("^[0-9]+$", n)`로만 검증할 경우, 매우 큰 숫자를 입력했을 때 `as.integer()`에서 integer overflow coercion이 발생하여 `NA`를 반환하며 어플리케이션 크래시를 유발할 수 있습니다.
**Learning:** R에서 정규식을 이용해 숫자를 검증하고 바로 변환하는 것은 오버플로우나 타입 에러에 취약합니다. 제한된 옵션을 입력받을 경우 엄격한 값 매칭을 사용해야 합니다.
**Prevention:** `n %in% c("1", "2")`와 같이 사전에 정의된 안전한 옵션 값과 직접 매칭하는 방식을 사용하여 입력값을 검증해야 합니다.
