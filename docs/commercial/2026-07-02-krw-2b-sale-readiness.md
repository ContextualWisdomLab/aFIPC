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

- Install/load:
  package installs and loads from source without runtime prompt requirements.
  Current artifact: `R CMD check --no-manual --as-cran`.
- Core API:
  `autoFIPC()` and `surveyFA()` are exported and documented.
  Current artifacts: `NAMESPACE`, `man/*.Rd`, and README.
- Non-interactive use:
  `autoFIPC()` has coverage for non-interactive execution.
  Current artifact: `tests/testthat/test-package-api.R`.
- Fixed-parameter behavior:
  common-item fixed-parameter linking is protected by regression fixtures.
  Current artifacts:
  `tests/testthat/test-fixed-parameter-calibration.R` and
  `test-regression-fixtures.R`.
- Fallback behavior:
  `surveyFA()` can return a fitted `mirt` model for recoverable input.
  Current artifact: `tests/testthat/test-surveyFA.R`.
- Failure behavior:
  unrecoverable fallback attempts stop with a bounded, explicit message.
  Current artifact: `tests/testthat/test-surveyFA.R`.
- Quality gate:
  local validation finishes with test failures/warnings at zero and package
  check errors/warnings at zero.
  Current artifacts: `scripts/validate-sale-readiness.R` and
  `docs/validation/2026-07-02-sale-readiness-evidence.md`.
- Operations:
  maintainer workflow, risk policy, and release gate are documented.
  Current artifact: `docs/operations/maintenance-runbook.md`.
- Architecture:
  runtime shape and high-risk areas are documented.
  Current artifacts: `ARCHITECTURE.md` and `AGENTS.md`.
- Security intake:
  vulnerability reporting path is present.
  Current artifact: `.github/SECURITY.md`.
- Sale-room index:
  buyer sequence, structure decision, plugin artifacts, and checklist are
  documented.
  Current artifact: `docs/commercial/2026-07-02-sale-room-index.md`.

## Repository Structure Decision

For the current KRW 2B target transaction package, keep `aFIPC` as one R package
and one sale unit. Do not split a separate library and do not introduce a
submodule before buyer acceptance.

This preserves the existing validation surface and avoids creating a new
integration boundary that would require additional numerical-equivalence
evidence. A later split is acceptable only after buyer acceptance and only when
new regression fixtures prove the extracted unit preserves current behavior.

## Buyer Handover Checklist

Before sharing a sale-room snapshot, complete these steps and record the commit
SHA in the evidence log:

1. Confirm the worktree is clean.
2. Run `R_PROFILE_USER=/dev/null Rscript scripts/validate-sale-readiness.R`.
3. Confirm the script prints `SALE_READINESS_OK`.
4. Confirm `NAMESPACE` exports only supported public functions.
5. Confirm README links to the completion baseline and diligence evidence.
6. Confirm no pending local-only dependency or data file is required to run tests.
7. Review `docs/commercial/2026-07-02-sale-room-index.md`.
8. Confirm Figma board/deck access for the buyer without using Code Connect.
9. List unresolved risks explicitly rather than hiding them in sales language.

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
