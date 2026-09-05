## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-24 - [대화형 입력 검증 시 정수 오버플로우 방지]
**Vulnerability:** `readline()` 함수로 사용자의 숫자를 입력받을 때, `^[0-9]+$` 정규식을 사용하여 입력 길이를 제한하지 않았습니다. 이로 인해 허용 범위를 초과하는 매우 큰 숫자가 입력될 경우 `as.integer()`에서 `NA`로 평가되어 이후 프로세스에서 크래시가 발생할 수 있는 취약점이 발견되었습니다.
**Learning:** 사용자 입력 검증 시에는 단순히 숫자인지 여부만 확인하는 것이 아니라, 예상되는 정확한 값(예: 1 또는 2)만을 허용하도록 제한해야 애플리케이션의 안정성과 보안을 유지할 수 있다는 것을 배웠습니다.
**Prevention:** 대화형 R 스크립트에서 입력을 검증할 때는 `^[0-9]+$`와 같은 제한 없는 숫자 클래스 대신 `^[12]$`와 같이 예상되는 정확한 값과 일치하도록 정규식을 엄격하게 정의해야 합니다.
