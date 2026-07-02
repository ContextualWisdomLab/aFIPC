# aFIPC KRW 2B Sale-Room Index

## Purpose

This index organizes the buyer-facing diligence package for presenting `aFIPC`
as a KRW 2B target technical asset. It is not a price guarantee, legal opinion,
tax opinion, or IP assignment document. It is the repository-native checklist a
buyer can use to reproduce the technical state without relying on chat history.

## Completion Standard

The sale-room package is complete when all of the following are true:

1. `R_PROFILE_USER=/dev/null Rscript scripts/validate-sale-readiness.R` prints
   `SALE_READINESS_OK`.
2. `testthat` reports 0 failures, 0 warnings, and 0 skips for critical package
   tests.
3. `R CMD check --no-manual --as-cran` reports 0 errors and 0 warnings.
4. The CRAN incoming "New submission" NOTE, if present, is recorded as a
   documented non-blocker.
5. The repository contains current diligence, validation, handover, and risk
   documentation.
6. Figma artifacts exist for buyer review and do not use Code Connect.
7. Any external review or GitHub workflow latency is separated from actual
   code/test/security defects.

## Repository Evidence

| Evidence Area | Source | Buyer Action |
| --- | --- | --- |
| Package source | `R/`, `DESCRIPTION`, `NAMESPACE`, `man/` | Inspect exported API and package metadata. |
| Validation gate | `scripts/validate-sale-readiness.R` | Run the command from the repository root. |
| Technical sale pack | `docs/commercial/2026-07-02-krw-2b-sale-readiness.md` | Review scope, completion criteria, and limits. |
| Plugin execution plan | `docs/commercial/2026-07-02-plugin-sale-readiness-plan.md` | Review plugin-deliverable mapping and final gate. |
| Validation evidence | `docs/validation/2026-07-02-sale-readiness-evidence.md` | Compare local output with required summaries. |
| Architecture | `ARCHITECTURE.md` | Confirm runtime shape and high-risk areas. |
| Maintainer operations | `docs/operations/maintenance-runbook.md` | Confirm repeatable maintenance workflow. |
| Security intake | `.github/SECURITY.md` | Confirm vulnerability reporting path. |
| CI policy | `.github/workflows/`, `.github/dependabot.yml` | Confirm actions and dependency hygiene. |

## Figma Artifacts

Code Connect is explicitly excluded.

| Artifact | Status | Location |
| --- | --- | --- |
| FigJam execution board | Created and updated with the v2 sale-readiness gate. | <https://www.figma.com/board/jD7NBmiuHUC0SRPhkTAGJk> |
| Figma Slides buyer deck | Generated for buyer/investment-committee review. | Copy the canonical Figma Slides URL from the generated preview before external sharing. |
| One-page executive brief | Planned derivative of the deck and this index. | Create from this index if the buyer requires a single-page PDF. |

## Product Design Frame

### Buyer Personas

| Persona | Primary Need | Acceptance Signal |
| --- | --- | --- |
| Assessment publisher | Preserve fixed-item linking behavior across forms. | Regression fixtures demonstrate stable linking paths. |
| Psychometrics team | Inspect calibration behavior without interactive prompts. | `autoFIPC()` and `surveyFA()` are documented and covered by tests. |
| Edtech platform | Evaluate whether legacy IRT calibration logic can be acquired and maintained. | Package check, runbook, architecture notes, and security intake are present. |
| Research lab | Reproduce and extend historical calibration workflows. | Source package, docs, and local validation command are available. |

### Jobs To Be Done

| Job | Package Response |
| --- | --- |
| Run fixed-parameter calibration and linking from source. | Preserve `autoFIPC()` and existing numerical behavior. |
| Recover from selected `surveyFA()` estimation failures. | Use bounded `mirt`-native fallback attempts before explicit failure. |
| Prove technical diligence without private data. | Use synthetic fixtures and `scripts/validate-sale-readiness.R`. |
| Handover the asset to a buyer's technical team. | Provide README, architecture, runbook, security policy, and this index. |

### Product Promise

`aFIPC` provides a reproducible R package surface for fixed-item parameter
calibration and test linking, with documented validation gates and buyer
diligence materials.

### Non-Promise

`aFIPC` does not guarantee successful calibration for arbitrary noisy assessment
data, a specific transaction price, CRAN acceptance, legal transferability, or a
third-party review timeline.

## Structure Decision

Decision: keep `aFIPC` as one R package and one sale unit for the current
transaction package. Do not split a separate library and do not add a submodule
before buyer acceptance.

Rationale:

- The current `SALE_READINESS_OK` gate validates the package as a whole.
- Splitting `R/aFIPC.R`, `surveyFA()`, tests, or validation tooling before sale
  would create a new integration surface and require new regression evidence.
- A submodule would add ownership, version-pinning, and buyer checkout friction
  without reducing current technical risk.
- The buyer is acquiring a compact R package plus operational evidence, not a
  multi-repository platform.

Approved future option:

- After buyer acceptance, extract validation tooling or a narrow calibration
  helper library only if the buyer requests an SDK boundary.
- Any extraction must first add regression fixtures that prove numerical
  equivalence before and after the split.
- The extracted unit should be versioned as a normal R package or internal
  repository; submodule use should be reserved for independently owned assets
  with a fixed external release cadence.

## Data Analytics Evidence

| Metric | Current Required State | Evidence Source |
| --- | --- | --- |
| Test failures | 0 | `scripts/validate-sale-readiness.R` |
| Test warnings | 0 | `scripts/validate-sale-readiness.R` |
| Test skips | 0 for critical package tests | `scripts/validate-sale-readiness.R` |
| R CMD check errors | 0 | `scripts/validate-sale-readiness.R` |
| R CMD check warnings | 0 | `scripts/validate-sale-readiness.R` |
| R CMD check notes | Documented if present | Validation evidence doc |
| GitHub workflow runs for local baseline commit | None returned for PR-triggered workflow lookup | Data Analytics/GitHub lookup on 2026-07-02 |

Interpretation:

- Local validation is the authoritative completion gate for this branch until it
  is pushed and a PR-triggered workflow exists.
- A missing PR-triggered workflow run is a process state, not a product defect.
- After push or PR creation, attach the latest workflow run ID and conclusion to
  this index or to a dated validation evidence appendix.

## Superpowers Execution Loop

| Step | Done When | Blocker? |
| --- | --- | --- |
| Inspect | Current branch, worktree, docs, validation gate, and GitHub evidence are checked. | Yes, if repository state cannot be read. |
| Implement | Sale-room docs and Figma assets are updated without changing numerical logic. | Yes, if required files cannot be edited. |
| Validate | `scripts/validate-sale-readiness.R` prints `SALE_READINESS_OK`. | Yes, if package errors/warnings appear. |
| Document | Known limits, structure decision, plugin roles, and buyer actions are recorded. | Yes, if unresolved product risks are hidden. |
| Commit | Changes are grouped as a sale-package refresh. | No, if local verification is complete but remote review is delayed. |

## Blocker Policy

Blocking:

- `R CMD check` error or warning under the sale gate.
- Failed regression test for `autoFIPC()` or `surveyFA()`.
- Undocumented algorithmic behavior change.
- Missing vulnerability reporting path.
- Missing or misleading risk disclosure.

Non-blocking when documented:

- Review-bot delay.
- Missing PR-triggered workflow run before the branch is pushed.
- CRAN incoming "New submission" NOTE.
- Historical `packrat/` modernization work.
- Buyer legal, tax, price, or IP-assignment process.

## Ponytail Positioning

Package name for sale materials:

- `aFIPC Fixed-Parameter Calibration Package`

Short positioning statement:

- aFIPC is a reproducible R package for fixed-item parameter calibration and
  test linking, packaged with validation gates and buyer diligence evidence.

Risk-safe claim language:

- "validated by a single local sale-readiness command" is acceptable when the
  command has just passed.
- "worth KRW 2B" is not acceptable as a technical claim; use "KRW 2B target
  transaction framing" unless a buyer offer exists.
- "calibrates all data" is not acceptable; use "preserves documented and tested
  calibration/linking behavior."

Buyer handover email draft:

```text
Subject: aFIPC technical diligence package

We are sharing the aFIPC Fixed-Parameter Calibration Package for technical
diligence. The package includes source, documentation, validation evidence,
Figma review assets, known limits, and a repeatable local validation command.

Please begin with docs/commercial/2026-07-02-sale-room-index.md, then run:

R_PROFILE_USER=/dev/null Rscript scripts/validate-sale-readiness.R

The package is presented as a KRW 2B target technical asset. Price, legal
assignment, tax, repository transfer, and buyer acceptance remain commercial and
legal workstreams outside the codebase.
```

## Final Buyer Checklist

Before external sharing, the seller should:

1. Run the sale-readiness validation script.
2. Confirm the worktree is clean.
3. Record the handover commit SHA.
4. Confirm Figma board/deck access for the buyer and record the Slides URL.
5. Push the branch or tag if remote CI evidence is required.
6. Attach latest GitHub workflow result after push/PR creation.
7. Disclose all known limits in this index and the diligence pack.
