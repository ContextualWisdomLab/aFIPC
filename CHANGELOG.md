# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 변경됨 (Changed)
- `autoFIPC` 함수의 대화형 프롬프트(`readline()`)에 대한 유효성 검사를 보다 안전하고 명확하게 수정했습니다. 기존의 숫자 정규식 일치 방식에서 `n %in% c("1", "2")`와 같은 명시적 문자열 일치 방식으로 변경하여 극단적인 값(정수 오버플로우 등) 입력 시 발생할 수 있는 크래시 위험을 방지하고 CLI 사용자 경험(UX)을 향상시켰습니다.
- 대화형 프롬프트 처리 로직을 `get_confirmation` 내부 헬퍼 함수로 분리하여 단위 테스트(`testthat`) 커버리지를 100% 달성할 수 있도록 리팩토링했습니다.
