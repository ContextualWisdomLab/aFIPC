# Sentinel Journal

## 2024-07-12 - Fix missing parameter validations

**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause
process crashes (`condition has length > 1`) or unexpected coercion
vulnerabilities.

**Learning:** In R, optional boolean parameters that default to `NULL` should
be validated using explicit runtime type validation (e.g.,
`if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).

**Prevention:** Always implement explicit runtime type validation for optional
boolean parameters.

## 2024-05-18 - 🛡️ Sentinel: [CRITICAL] 정수 오버플로우 프로세스 크래시 완화

**Vulnerability:** 대화형 쉘 환경에서 `readline()`을 통해 사용자 입력을 받을 때,
무한 자릿수의 정수를 허용하는 느슨한 정규표현식(`^[0-9]+$`) 검증 로직이
존재했습니다. 만약 엄청나게 큰 숫자의 문자열을 입력받을 경우 정규식은 통과되지만
`as.integer()`로 변환 시 `NA`가 반환되어, 이어지는 조건문이나 수식에서
`integer overflow coercion` 에러로 인해 프로세스가 크래시될 가능성이 높았습니다.

**Learning:** R에서 정규식을 이용해 입력값을 받을 때는 예상하는 구체적인 값(예: 1
또는 2)만을 명시적으로 일치시키도록 검증해야 입력값 변환 과정에서 발생하는
예기치 못한 에러와 DoS 취약점을 방지할 수 있다는 점을 확인했습니다.

**Prevention:** 향후 입력값을 검증할 때는 `^[0-9]+$`와 같이 무제한 자리수의
숫자 검증을 피하고, 허용되는 정확한 값(예: `^[12]$`)만 입력되도록 방어적인
검증 코드를 작성해야 합니다.
