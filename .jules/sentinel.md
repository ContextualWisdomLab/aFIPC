## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-05-24 - [정수 오버플로우 방지를 위한 입력 검증 강화]
**Vulnerability:** `readline()`을 통해 사용자 입력을 받을 때 `^[0-9]+$` 정규식을 사용하여 입력을 검증했습니다.
**Learning:** `^[0-9]+$` 정규식은 제한이 없어 매우 큰 숫자가 입력될 경우 `as.integer()`에서 정수 오버플로우(integer overflow)가 발생해 `NA`를 반환하고, 이로 인해 이후 로직에서 예상치 못한 에러나 프로세스 크래시를 유발할 수 있음을 확인했습니다.
**Prevention:** `readline()`으로 `1` 또는 `2`와 같이 제한된 선택지만 받아야 하는 경우에는 `^[12]$`와 같이 구체적이고 정확한 정규식으로 엄격하게 검증하여 예측 불가능한 값의 입력을 원천 차단해야 합니다.
