## 2024-07-12 - Fix missing parameter validations
**Vulnerability:** Unvalidated inputs passed to `if()` statements can cause process crashes (`condition has length > 1`) or unexpected coercion vulnerabilities.
**Learning:** In R, optional boolean parameters that default to `NULL` should be validated using explicit runtime type validation (e.g., `if (!is.null(flag) && (!is.logical(flag) || length(flag) != 1 || is.na(flag)))`).
**Prevention:** Always implement explicit runtime type validation for optional boolean parameters.
## 2024-08-01 - Dependabot 설정 시 Supply Chain 공격 예방을 위한 Cooldown 기간 설정
**Vulnerability:** 악의적인 행위자가 유명 패키지를 탈취하거나 유사한 이름의 패키지를 배포한 직후, 자동화된 의존성 업데이트 도구(Dependabot 등)가 이를 즉시 병합하도록 유도하는 공급망(Supply Chain) 공격에 취약할 수 있습니다. Semgrep의 `dependabot-missing-cooldown` 규칙에서 이를 탐지합니다.
**Learning:** 새로 게시된 패키지 버전이 악성이거나 불안정할 수 있으므로 일정 기간 검증할 시간이 필요합니다.
**Prevention:** `.github/dependabot.yml`의 `package-ecosystem` 업데이트 항목에 `cooldown: default-days: 7`과 같이 7일 이상의 지연 대기 기간을 설정하여 업데이트 검토 기간을 확보해야 합니다.
