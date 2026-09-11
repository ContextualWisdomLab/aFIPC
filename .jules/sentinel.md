## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2024-07-26 - 정수 오버플로우 강제 변환 취약점 수정
**Vulnerability:** 대화형 `readline()` 입력에서 숫자 옵션을 검증할 때 제한 없는 숫자 클래스(예: `^[0-9]+$`)를 사용하면, 너무 큰 숫자가 정규표현식 검사를 통과한 후 `as.integer()`에서 `NA`로 평가되어 후속 프로세스 충돌을 유발할 수 있습니다.
**Learning:** R 스크립트에서 대화형 `readline()` 숫자 입력을 검증할 때, 제한 없는 숫자 클래스보다 정확히 예상되는 값(예: `^[12]$`)과 엄격하게 일치시켜야 합니다.
**Prevention:** 정수 오버플로우 강제 변환 취약점을 방지하기 위해 대화형 세션에서 예상되는 숫자 입력 옵션에 대해 항상 정밀한 정규표현식 매칭을 사용해야 합니다.
