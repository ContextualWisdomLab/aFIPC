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

## 2024-06-30 - Prevent Infinite Loop DoS in User Prompts
**Vulnerability:** The code used `readline()` inside an unbounded `while` loop to validate user inputs. In environments where standard input is continuously piped or automated incorrectly, `readline()` repeatedly returns invalid inputs (like `""`), causing the loop to run infinitely. This leads to 100% CPU utilization and eventual service denial (DoS).
**Learning:** Even when `interactive()` safeguards are present, user-provided loops over `readline()` are dangerous without an upper bound, as inputs can still be automated or maliciously piped in interactive-like environments.
**Prevention:** Always include a `max_retries` counter (e.g., 5) and break or `stop()` when the limit is reached to prevent unbounded looping.
