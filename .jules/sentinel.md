## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-05-24 - [보안: 정수 오버플로 및 DoS 취약점 수정]
**Vulnerability:** 대화형 입력(`readline`) 시 `grepl("^[0-9]+$", n)` 정규식만으로 입력값을 검증하여, 매우 큰 숫자가 입력되었을 때 `as.integer()`에서 오버플로가 발생(`NA` 반환)해 이후 논리 연산에서 애플리케이션 크래시(DoS)가 발생하는 취약점이 존재함.
**Learning:** `grepl("^[0-9]+$", n)`은 단순한 숫자 형태인지만 검사하므로 정수 표현 범위를 초과하는 악의적 입력이나 극단적으로 큰 값을 걸러내지 못함. R에서 `NA`는 논리 연산식에 들어가면 에러를 발생시킴.
**Prevention:** 미리 정의된 선택지(예: "1", "2")만 입력받는 경우, 정규식 대신 정확한 값 일치(`n %in% c("1", "2")`)를 통해 안전하게 입력을 검증해야 함.
