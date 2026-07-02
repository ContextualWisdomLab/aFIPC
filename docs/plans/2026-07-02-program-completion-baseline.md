# Program Completion Baseline

## Completion Standard

Treat `aFIPC` as program-complete only when all of the following are true:

- the package installs and loads from a clean checkout;
- `autoFIPC()` is exported and usable in non-interactive test runs;
- fixed-parameter linking behavior is protected by regression fixtures;
- estimation failure paths are bounded and fail clearly;
- `R CMD check --as-cran` completes without errors or warnings;
- maintainer docs describe the live repository, duplicate PR policy, and
  dependency-modernization boundaries;
- no broad calibration or linking behavior changes land without explicit
  maintainer-approved numerical regression evidence.

Treat `aFIPC` as **commercially sale-ready** only when all of the above are true
plus:

- fallback recovery for `surveyFA()` is bounded and deterministic;
- fallback returns a fitted `mirt` model for recoverable input when possible;
- fallback exhaustion reports an explicit reason and list of removed items.

Treat `aFIPC` as ready for a KRW 2B technical diligence package only when the
commercial sale-ready criteria are current and the following buyer-facing
artifacts exist:

- a sale-readiness diligence pack with included/excluded scope, handover
  checklist, known limits, and release recommendation;
- a verification evidence file that records exact local commands and current
  result interpretation;
- README links that let a buyer find the completion baseline and evidence
  without relying on chat history.

For commercial staging, external review-gate delays (예: OpenCode/리뷰 모델 가용성
이슈)은 기능 완성도 판단의 1차 Blocker가 되지 않는다. 품질 요건은
패키지 테스트/회귀·문서 증빙으로 판단한다.

## Current Baseline

This branch integrates the minimum safe completion baseline:

- regression fixtures for prior-update and IPD anchor behavior;
- bounded MHRM retry behavior for failed estimation fallback;
- maintainer planning/runbook documentation;
- explicit `stats::na.omit` namespace import;
- bounded `surveyFA()` fallback with alternate estimation and bounded autofix
  behavior;
- KRW 2B diligence pack and repeatable sale-readiness evidence documents.

## Release Blocker

`surveyFA()` is now implemented with a bounded mirt fallback path rather than
an immediate stop, while still rejecting non-recoverable malformed inputs.

The safe completion behavior is to attempt bounded recovery (alternate estimator,
bounded item removal), then fail clearly when recovery is exhausted.

The likely source family is `ContextualWisdomLab/kaefa`, which contains the
`aefa()` / `engineAEFA()` exploratory factor-analysis engine. It does not expose
a direct `surveyFA()` / `forceUIRT` / `forceMHRM` compatible API, so aFIPC now
implements its own bounded fallback.

`surveyFA()` implementation should still avoid broad algorithmic rewrites and must
remain covered by regression fixtures and explicit numeric-drift checks before any
future estimator behavior expansion.
