# Sale-Readiness Verification Evidence

## Purpose

This file records the repeatable verification evidence for the KRW 2B
sale-readiness package. It is intentionally command-oriented so a buyer or
maintainer can reproduce the result from a fresh checkout.

## Required Environment

- R with package build/check tooling available.
- Installed package dependencies declared in `DESCRIPTION`.
- Optional: `rcmdcheck` for CRAN-style local checks.
- No private secrets or external data files are required for the validation
  commands below.

## Verification Commands

Run from the repository root:

```bash
R_PROFILE_USER=/dev/null Rscript -e 'pkgload::load_all(); testthat::test_dir("tests/testthat")'
```

Required result:

- `FAIL 0`
- `WARN 0`
- `SKIP 0` for critical package tests

Run the CRAN-style package gate:

```bash
R_PROFILE_USER=/dev/null Rscript -e 'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

Required result:

- `0 errors`
- `0 warnings`
- CRAN incoming "New submission" notes may occur and should be recorded as
  non-functional release notes, not runtime failures.

## Current Evidence Snapshot

Last locally observed baseline on 2026-07-02:

- `testthat::test_dir("tests/testthat")`: 51 passing assertions, 0 failures,
  0 warnings, 0 skips.
- `R CMD check --no-manual --as-cran`: 0 errors, 0 warnings, 1 CRAN incoming
  note for new submission status.
- `surveyFA()` recovery test returns a fitted `mirt` `SingleGroupClass`.
- Unrecoverable `surveyFA()` input stops with a bounded recovery exhaustion
  message.

Because dependency and R versions can drift, this snapshot must be refreshed
before final buyer delivery.

## Evidence Interpretation

Sale-readiness is a technical acceptance state, not a business valuation proof.
The evidence means the codebase is organized, testable, and ready for buyer
technical diligence. It does not prove market price, legal ownership, IP
transferability, or buyer-specific fit.

## Diligence Blocker Policy

Blocking:

- `R CMD check` error.
- `R CMD check` warning under the documented sale gate.
- failing regression test for `autoFIPC()` or `surveyFA()`.
- undocumented algorithmic behavior change.
- missing security/contact policy for buyer intake.

Non-blocking when documented:

- review-bot or external review model delay.
- CRAN "New submission" note.
- historical `packrat/` modernization work.
- expected `mirt` warnings in small synthetic regression fixtures.
