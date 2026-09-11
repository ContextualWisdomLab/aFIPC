# Architecture Overview

This document is a living map for maintainers and coding agents. It explains
where the fixed-item parameter calibration implementation lives, how package
metadata and CI are wired, and which parts are safe to evolve.

## 1. Project Structure

`aFIPC/`

- `R/aFIPC.R` - Core implementation of `autoFIPC()` (calibration + linking)
- `DESCRIPTION` - Package metadata (name, version, imports, license)
- `NAMESPACE` - Export map for package functions
- `man/` - Generated R documentation (`.Rd` files)
- `packrat/` - Historical dependency lock/vendor directory
- `.github/workflows/` - CI + security automation
- `.github/SECURITY.md` - Vulnerability reporting policy
- `.github/PULL_REQUEST_TEMPLATE.md` - PR review checklist template
- `.github/ISSUE_TEMPLATE/` - structured issue intake templates
- `.github/CODEOWNERS` - code ownership map for reviews
- `.github/dependabot.yml` - Automated Actions dependency updates
- `.cursor/` - Cloud Agent environment (`environment.json` + `install.sh`)
- `docs/adr/` - architecture decision records (FIPC contract, mirt engine)
- `docs/fixed-parameter-item-calibration.md` - Kim (2006) linking contract
- `docs/papers/README.md` - verified bibliographic sources and DOIs
- `docs/coderabbit/review-commands.md` - CodeRabbit command quick reference
- `docs/operations/maintenance-runbook.md` - recurring maintainer operations checklist
- `README.md` - User/developer entrypoint
- `CONTRIBUTING.md` - Contribution process and verification baseline
- `AGENTS.md`, `CLAUDE.md` - Agent operation guardrails

## 2. High-Level System Diagram

`Analyst data (old/new forms)` -> `autoFIPC()` -> `mirt calibration` ->
`fixed-item parameter linking` -> `linked model + expected score/theta outputs`

The package is single-process and fileless at runtime. Inputs are in-memory
R objects (data frame/matrix/model), and outputs are returned as an R list.

## 3. Core Components

### 3.1 Calibration and Linking Engine

- Path: `R/aFIPC.R`
- Responsibility:
  - Calibrate old/new forms using `mirt`, with bounded QMCEM/MHRM/`surveyFA`
    recovery when an initial raw-data fit is unacceptable
  - Optionally detect item parameter drift (IPD)
  - Apply fixed common-item constraints for test linking
  - Fit the linked model with EM for nominal items or `tryEM = TRUE`, and MHRM
    otherwise
  - Produce linked model and score/theta artifacts
- Key dependency: `mirt`
- Method decision: FIPC (Kim, 2006), not Stocking-Lord (1983) or
  Haebara (1980) transformation estimation; see
  `docs/adr/0001-fipc-linking-contract.md`

### 3.2 Package Metadata and API Surface

- `DESCRIPTION`: package identity, imports, and license definition
- `NAMESPACE`: exported objects
- `man/autoFIPC.Rd`: generated docs for package consumers

### 3.3 Automation Layer

- `r.yml`: R CMD check workflow
- `code-quality.yml`: Markdown/YAML/workflow quality checks
- `security-audit.yml`: private-repo-compatible secret and workflow audit
- `codeql.yml`: Code scanning workflow for Actions language
- `dependency-review.yml`: dependency policy gate on pull requests
- `scorecard.yml`: supply-chain posture check and SARIF upload
- `dependabot.yml`: recurring update PRs for GitHub Actions

## 4. Data Stores

This repository has no production database. Persistent state is source code,
package metadata, and CI workflow definitions in Git.

## 5. External Integrations / APIs

- GitHub Actions runners
- GitHub code scanning SARIF ingestion
- CRAN-style package installation during checks

## 6. Deployment & Infrastructure

- Distribution mode: R package source repository
- CI/CD: GitHub Actions (`.github/workflows/*.yml`)
- Dependency updates: Dependabot

## 7. Security Considerations

- Actions are pinned to full commit SHAs.
- Private-repo-safe checks are enforced with `security-audit.yml` and required checks.
- CodeQL/dependency-review workflows are present but skipped when platform
  features are unavailable.
- No secrets are required for package checks.

## 8. Development & Testing Environment

- Primary check: `R CMD check` via GitHub Actions
- Local check command:
  - `Rscript -e 'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"))'`
- Cloud Agent: `.cursor/environment.json` runs `.cursor/install.sh` to provision
  CRAN-release R and r2u binaries (`mirt`, `testthat`, `roxygen2`, `rcmdcheck`).
  `install` is snapshot-scoped and must not `R CMD INSTALL` the current tree;
  use `testthat::test_local()` / `rcmdcheck` against the checkout.

## 9. Future Considerations / Roadmap

- Add non-interactive regression fixtures for historically trusted
  FIPC results.
- Reduce interactive prompts in `autoFIPC()` for automation friendliness.
- Evaluate migration path from historical `packrat/` to a modern
  lock workflow.

## 10. Bibliographic grounding

`autoFIPC()` orchestrates FIPC (Kim, 2006): anchors keep old-form
values and the new form is calibrated onto that scale. That contract
is an alternative to separate calibration plus Stocking and Lord
(1983) or Haebara (1980) characteristic-curve linking, and to
concurrent calibration (Kolen & Brennan, 2014). This repository does
not implement those transformation estimators.

Numerical estimation lives in `mirt` (Chalmers, 2012). The linked FIPC
fit uses MML-EM (Bock & Aitkin, 1981) for nominal items or when
`tryEM = TRUE`, and MHRM otherwise. Separately fitted old/new raw-data
models can recover through QMCEM, MHRM, and `surveyFA` variants after
an unacceptable initial fit, so a returned aFIPC result must not be
summarized as if every model artifact used MML-EM. Optional IPD
screening calls `mirt::multipleGroup` and `mirt::DIF` with the same
EM-versus-MHRM selection rule as the linked fit; it is not a published
invariance claim (see `docs/adr/0003-ipd-dif-screening-delegation.md`).
Score-scale interpretation is bounded by AERA, APA, and NCME (2014).

An earlier draft incorrectly attributed "Linking item parameters to a
base scale" to Kim and Kolen (2010) in JEM; that attribution was removed.
The title belongs to Kang and Petersen (2012). Kim and Kolen (2019) is
a separate, real later FIPC application paper.

Full APA 7th records and DOIs: `docs/papers/README.md`. Accepted
method ADRs: `docs/adr/`.

Kim, S. (2006). A comparative study of IRT fixed parameter calibration
methods. *Journal of Educational Measurement, 43*(4), 355-381.
<https://doi.org/10.1111/j.1745-3984.2006.00021.x>

Stocking, M. L., & Lord, F. M. (1983). Developing a common metric in
item response theory. *Applied Psychological Measurement, 7*(2),
201-210. <https://doi.org/10.1177/014662168300700208>

Haebara, T. (1980). Equating logistic ability scales by a weighted
least squares method. *Japanese Psychological Research, 22*(3),
144-149. <https://doi.org/10.4992/psycholres1954.22.144>

Kolen, M. J., & Brennan, R. L. (2014). *Test equating, scaling, and
linking: Methods and practices* (3rd ed.). Springer.
<https://doi.org/10.1007/978-1-4939-0317-7>

Kim, S., & Kolen, M. J. (2019). Application of IRT fixed parameter
calibration to multiple-group test data. *Applied Measurement in
Education, 32*(4), 310-324.
<https://doi.org/10.1080/08957347.2019.1660344>

Kang, T., & Petersen, N. S. (2012). Linking item parameters to a base
scale. *Asia Pacific Education Review, 13*(2), 311-321.
<https://doi.org/10.1007/s12564-011-9197-2>

Chalmers, R. P. (2012). mirt: A multidimensional item response theory
package for the R environment. *Journal of Statistical Software,
48*(6), 1-29. <https://doi.org/10.18637/jss.v048.i06>

Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood
estimation of item parameters: Application of an EM algorithm.
*Psychometrika, 46*(4), 443-459.
<https://doi.org/10.1007/BF02293801>

American Educational Research Association, American Psychological
Association, & National Council on Measurement in Education. (2014).
*Standards for educational and psychological testing*. American
Educational Research Association.

## 11. Project Identification

- Project Name: aFIPC
- Repository URL: `https://github.com/ContextualWisdomLab/aFIPC`
- Primary Contact: Seongho Bae
- Date of Last Update: 2026-08-16

## 12. Glossary / Acronyms

- FIPC: Fixed Item Parameter Calibration
- IPD: Item Parameter Drift
- IRT: Item Response Theory
- MML-EM: Marginal Maximum Likelihood via the EM algorithm
