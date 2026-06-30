## 2024-06-23 - 재귀적 입력 검증으로 인한 대화형 프롬프트 DoS 취약점
**Vulnerability:** 대화형 프롬프트 함수(`checkCorrect`, `checkoldformBILOGprior`, `checknewformBILOGprior`)에서 사용자가 올바르지 않은 값(예: 숫자가 아닌 문자열)을 입력했을 때, 꼬리 재귀(tail-recursive) 방식으로 자기 자신을 호출하도록 구현되어 있었습니다. 이는 R의 C 스택 사이즈 제한으로 인해 스택 고갈(Stack Exhaustion)로 이어지는 DoS(서비스 거부) 취약점을 야기할 수 있으며, `readline()`이 계속 빈 문자열을 반환하는 비대화형(non-interactive) CI/CD 환경에서는 무한 루프를 발생시켰습니다.
**Learning:** 입력 검증 루프는 재귀 호출을 사용하여 구현해서는 안 되며, 특히 자동화된 환경에서 입력이 제공될 때 더욱 주의해야 합니다. 비대화형 세션에서의 탈출구(escape hatch)가 없는 재귀적 입력 루프는 리소스를 즉시 고갈시켜 자동화된 테스트 및 CI 환경을 손상시킵니다.
**Prevention:**
1. 입력 검증 시 재귀 호출 대신 반복문 기반 검증을 사용합니다.
2. 수동 입력을 요구하기 전에 현재 세션이 대화형인지 확인하고, 비대화형 세션일 경우에는 명시적 기본값 또는 빠른 실패(fail-fast)로 처리합니다.

## 2024-06-23 - Prevent Infinite Recursion DoS in Interactive Prompts
**Vulnerability:** The legacy interactive prompts in `checkCorrect()`, `checkoldformBILOGprior()`, and `checknewformBILOGprior()` recursively call themselves if invalid input is provided via `readline()`. In non-interactive environments (e.g. CI/CD or background processes), `readline()` may instantly return `""` or fail, causing an infinite loop that leads to stack overflow or memory exhaustion (Denial of Service).
**Learning:** Legacy scripts originally intended for local interactive use often lack constraints for automated headless environments. Unbounded recursive prompts implicitly assume a human will eventually break the loop, failing dangerously when automated.
**Prevention:** Always assert the execution context before relying on manual intervention mechanisms. In non-interactive modes, fail fast for required confirmations and use bounded, iterative input validation for interactive prompts.

## 2024-05-24 - [CRITICAL] 무한 재귀 호출(Infinite Recursion) DoS 취약점 수정
**Vulnerability:** `R/aFIPC.R` 파일 내 `autoFIPC` 함수의 내부 헬퍼 함수들(`checkCorrect`, `checkoldformBILOGprior`, `checknewformBILOGprior`)이 잘못된 입력 처리 시 제한 없이 재귀 호출을 수행했습니다. 이로 인해 비대화형(non-interactive) 환경이나 자동화된 잘못된 입력이 주어질 때 무한 루프에 빠져 스택 오버플로우 및 서비스 거부(DoS)가 발생할 수 있었습니다.
**Learning:** 대화형(interactive) 스크립트로 설계된 레거시 R 코드가 패키지화될 때, CI/CD나 자동화 환경에서 `readline`의 재귀적 호출이 무한 루프로 이어지는 구조적 결함을 확인했습니다. 대화형 입력을 요구하는 코드에는 항상 비대화형 환경에 대한 예외 처리 및 재귀 제한이 필수적입니다.
**Prevention:** 사용자 입력을 요구하거나 재시도하는 로직에서는 반드시 `interactive()` 함수를 통해 세션 상태를 확인하고, 재시도 횟수 제한 또는 반복문 기반 입력 검증을 두어 무한 재귀를 방지해야 합니다.

## 2026-06-22 - Prevent infinite loops from readline in non-interactive sessions
**Vulnerability:** The code uses `readline()` in `R/aFIPC.R` to prompt the user. In non-interactive environments (e.g., CI/CD, automation scripts, agents), this can block execution or leave the process consuming resources.
**Learning:** `readline()` should only be used when `interactive()` is true. Interactive prompts are insecure and unstable in automated contexts because they block execution unconditionally.
**Prevention:** Always wrap `readline()` logic in an `if (interactive())` check or provide sensible defaults for non-interactive execution.
