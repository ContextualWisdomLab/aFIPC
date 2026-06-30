# Changelog

## [Unreleased]
### Security
- `R/aFIPC.R`: `readline` 입력 검증 과정에서 비대화형(non-interactive) 환경이거나 잘못된 입력이 반복될 때 발생할 수 있는 무한 재귀 호출(Infinite recursion) 및 서비스 거부(DoS) 취약점을 수정했습니다. (최대 재시도 횟수 제한 및 비대화형 환경 예외 처리 추가)
