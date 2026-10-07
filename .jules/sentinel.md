## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
## 2024-10-07 - 대화형 Readline 프롬프트 유효성 검사 개선
**Vulnerability:** 대화형 프롬프트 입력값에 대해 `grepl("^[0-9]+$", n)`과 같이 범위 제한 없는 정규식을 사용하면 R의 최대 정수 한계를 넘는 값이 허용되어 `as.integer(n)` 변환 시 `NA`를 반환하고, 이로 인해 후속 조건문에서 프로그램이 충돌(condition has length > 1)할 위험이 존재합니다.
**Learning:** `grepl("^[0-9]+$", ...)`은 정수형 입력값의 논리적 범위 제한이나 오버플로우를 막아주지 못합니다.
**Prevention:** 정해진 문자열 입력값(예: `n == "1" || n == "2"`)과 정확히 일치하는지 엄격하게 검증하여 개방형 정규식과 정수 강제 변환에 의존하지 않도록 합니다.
