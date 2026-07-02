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

## Current Baseline

This branch integrates the minimum safe completion baseline:

- regression fixtures for prior-update and IPD anchor behavior;
- bounded MHRM retry behavior for failed estimation fallback;
- maintainer planning/runbook documentation;
- explicit `stats::na.omit` namespace import;
- explicit `surveyFA()` failure while its historical fallback algorithm remains
  unimplemented.

## Release Blocker

`surveyFA()` is still not a complete fallback implementation. It was previously
an exported NULL-returning stub, which could fail later with unclear slot-access
errors inside `autoFIPC()` fallback paths.

The safe completion behavior is to fail immediately with a clear message until a
maintainer supplies the intended fallback algorithm and regression fixtures.

The likely source family is `ContextualWisdomLab/kaefa`, which contains the
`aefa()` / `engineAEFA()` exploratory factor-analysis engine. It does not expose
a direct `surveyFA()` / `forceUIRT` / `forceMHRM` compatible API, so aFIPC should
not depend on it until a small adapter is designed and validated.

Do not implement `surveyFA()` by guessing at replacement calibration logic. That
would be an algorithmic behavior change and must be handled as a separate
numerical-validation task.
