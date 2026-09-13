## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.

## 2026-09-13 - 대화형 이진 선택 입력을 실제 허용 집합으로 제한
**Finding:** 세 대화형 프롬프트가 `1`과 `2`만 의미 있게 사용하면서도 모든 숫자 문자열을 먼저 허용했습니다. 매우 큰 숫자는 `as.integer()`에서 `NA`가 되어 제어 흐름 오류를 만들 수 있고, `0`이나 `3`도 의미 없는 값으로 후속 분기에 들어갈 수 있었습니다.
**Learning:** 선택형 입력은 숫자 여부를 넓게 확인한 뒤 변환하기보다 실제 도메인 허용값을 그대로 검증해야 합니다. 이 경로는 로컬 대화형 입력이므로 별도의 원격 신뢰 경계가 입증되지 않은 상태에서 보안 심각도를 부여하지 않습니다.
**Prevention:** 공통 문항 확인과 old/new-form BILOG prior 프롬프트 모두 문자열 `"1"` 또는 `"2"`만 정확히 허용하고, 그 밖의 값은 제한된 재시도 뒤 통제된 오류로 종료합니다.
