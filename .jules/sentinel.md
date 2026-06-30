## 2024-06-23 - 재귀적 입력 검증으로 인한 대화형 프롬프트 DoS 취약점
**Vulnerability:** 대화형 프롬프트 함수(`checkCorrect`, `checkoldformBILOGprior`, `checknewformBILOGprior`)에서 사용자가 올바르지 않은 값(예: 숫자가 아닌 문자열)을 입력했을 때, 꼬리 재귀(tail-recursive) 방식으로 자기 자신을 호출하도록 구현되어 있었습니다. 이는 R의 C 스택 사이즈 제한으로 인해 스택 고갈(Stack Exhaustion)로 이어지는 DoS(서비스 거부) 취약점을 야기할 수 있으며, `readline()`이 계속 빈 문자열을 반환하는 비대화형(non-interactive) CI/CD 환경에서는 무한 루프를 발생시켰습니다.
**Learning:** 입력 검증 루프는 재귀 호출을 사용하여 구현해서는 안 되며, 특히 자동화된 환경에서 입력이 제공될 때 더욱 주의해야 합니다. 비대화형 세션에서의 탈출구(escape hatch)가 없는 재귀적 입력 루프는 리소스를 즉시 고갈시켜 자동화된 테스트 및 CI 환경을 손상시킵니다.
**Prevention:**
1. 입력 검증 시 재귀 호출 대신 `repeat` 루프를 사용합니다.
2. 수동 입력을 요구하기 전에 항상 `!interactive()`를 사용하여 현재 세션이 대화형인지 확인하고, 비대화형 세션일 경우에는 즉시 에러를 발생시켜 안전하게 실패(fail securely)하도록 처리합니다.
3. common item 확인처럼 추정 결과의 기준척도와 true parameter 재현에 직접 영향을 주는 입력은 비대화형 환경에서 기본값으로 자동 승인하지 않습니다. 자동화에서는 `confirmCommonItems = TRUE`처럼 명시적 opt-in을 요구합니다.
