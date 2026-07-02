# KRW 2B Sale-Readiness Diligence Pack

## Decision

`aFIPC` is considered ready for a KRW 2B sale diligence package when the
criteria in this document are satisfied with current local or CI evidence.

This document does not guarantee price, buyer demand, or legal closing. It
defines the technical, operational, and handover evidence required so a buyer can
evaluate the program without relying on chat history or unavailable review bots.

## Sale-Ready Scope

Included product scope:

- R package source for fixed-item parameter calibration and IRT test linking.
- Public API: `autoFIPC()` and `surveyFA()`.
- Bounded `surveyFA()` fallback path for recoverable calibration failures.
- Regression fixtures for fixed-parameter linking and selected failure paths.
- GitHub Actions and local verification commands for package quality checks.
- Maintainer runbooks, architecture notes, and security/contact policy.

Excluded from this sale-ready claim:

- Any promise that arbitrary noisy assessment data will calibrate successfully.
- Any broad numerical behavior rewrite beyond the tested fallback path.
- Any migration from historical `packrat/` to a modern lockfile system.
- Any guarantee that third-party review bots will respond within a timeline.
- Any legal, tax, pricing, or IP assignment conclusion.

## Completion Criteria

The package may be presented as technically sale-ready only when all criteria
below are true.

| Area | Required Evidence | Current Artifact |
| --- | --- | --- |
| Install/load | Package installs and loads from source without runtime prompt requirements. | `R CMD check --no-manual --as-cran` |
| Core API | `autoFIPC()` and `surveyFA()` are exported and documented. | `NAMESPACE`, `man/*.Rd`, README |
| Non-interactive use | `autoFIPC()` has test coverage for non-interactive execution. | `tests/testthat/test-package-api.R` |
| Fixed-parameter behavior | Common-item fixed-parameter linking is protected by regression fixtures. | `tests/testthat/test-fixed-parameter-calibration.R`, `test-regression-fixtures.R` |
| Fallback behavior | `surveyFA()` can return a fitted `mirt` model for recoverable input. | `tests/testthat/test-surveyFA.R` |
| Failure behavior | Unrecoverable fallback attempts stop with a bounded, explicit message. | `tests/testthat/test-surveyFA.R` |
| Quality gate | Single-command local validation finishes with test warnings/failures at zero and package check errors/warnings at zero. | `scripts/validate-sale-readiness.R`, `docs/validation/2026-07-02-sale-readiness-evidence.md` |
| Operations | Maintainer workflow, risk policy, and release gate are documented. | `docs/operations/maintenance-runbook.md` |
| Architecture | Runtime shape and high-risk areas are documented. | `ARCHITECTURE.md`, `AGENTS.md` |
| Security intake | Vulnerability reporting path is present. | `.github/SECURITY.md` |

## Buyer Handover Checklist

Before sharing a sale-room snapshot, complete these steps and record the commit
SHA in the evidence log:

1. Confirm the worktree is clean.
2. Run `R_PROFILE_USER=/dev/null Rscript scripts/validate-sale-readiness.R`.
3. Confirm the script prints `SALE_READINESS_OK`.
4. Confirm `NAMESPACE` exports only supported public functions.
5. Confirm README links to the completion baseline and diligence evidence.
6. Confirm no pending local-only dependency or data file is required to run tests.
7. List unresolved risks explicitly rather than hiding them in sales language.

## Known Limits

These limits should be disclosed during diligence because they affect buyer
expectations but do not block technical sale-readiness:

- The package preserves legacy numerical behavior; large rewrites require new
  regression fixtures and maintainer approval.
- `packrat/` is historical vendor state and remains modernization scope.
- CRAN incoming feasibility may report a "New submission" note when checked as a
  package that has not previously been submitted to CRAN.
- Some small synthetic calibration fixtures may emit `mirt` identification
  warnings while still exercising the intended package behavior.
- Review-bot delays are external process delays and are not functional blockers.

## Release Recommendation

For a KRW 2B sale process, classify the current branch as:

**Technical diligence ready after local verification is current and the worktree
is clean.**

Do not classify it as fully closed/commercially transferred until legal
assignment, license review, repository transfer, and buyer acceptance have been
completed outside the codebase.
