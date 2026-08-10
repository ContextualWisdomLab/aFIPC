# Sentinel Journal

## 2024-07-12 - Fix missing parameter validations

**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause
process crashes (`condition has length > 1`) or unexpected coercion
vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should
be validated using explicit runtime type validation (e.g.,
`if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for
optional boolean parameters.

## 2024-08-10 - [사용자 입력 검증 강화 및 정수 오버플로우 방지]

**Vulnerability:** 대화형 프롬프트(`readline()`)에서 사용자의 입력을 검증할
때 `grepl("^[0-9]+$", n)`과 같이 무제한의 숫자를 허용하여 큰 숫자가 입력될
경우 `as.integer()`에서 `NA`를 반환하는 등의 정수 오버플로우 및 강제 변환
취약점이 발생할 위험이 있었습니다.
**Learning:** 기대하는 입력값(예: 1 또는 2)의 범위가 명확함에도
정규표현식 매칭을 너무 광범위하게 허용하는 것은 에러 처리가 되지 않은 상태에서
예상치 못한 형변환 결과를 초래하여 프로세스가 강제 종료될 수 있는 보안
리스크임을 배웠습니다.
**Prevention:** 대화형 프롬프트나 텍스트 기반 입력에서 정수형 변환을 수행하기
전에, 허용 가능한 정확한 값(예: `^[12]$`)에 대해서만 엄격하게 정규식 매칭을
수행하도록 해야 합니다.
