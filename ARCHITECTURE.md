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
  - Calibrate old/new forms using `mirt`
  - Optionally detect item parameter drift (IPD)
  - Apply fixed common-item constraints for test linking
  - Produce linked model and score/theta artifacts
- Key dependency: `mirt`

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

## 9. Future Considerations / Roadmap

- Expand regression fixtures beyond current prior-update/IPD-anchor
  scenarios to additional historically trusted FIPC configurations.
- Reduce interactive prompts in `autoFIPC()` for automation friendliness.
- Evaluate migration path from historical `packrat/` to a modern
  lock workflow.

## 10. Project Identification

- Project Name: aFIPC
- Repository URL: `https://github.com/seonghobae/aFIPC`
- Primary Contact: Seongho Bae
- Date of Last Update: 2026-02-15

## 11. Glossary / Acronyms

- FIPC: Fixed Item Parameter Calibration
- IPD: Item Parameter Drift
- IRT: Item Response Theory
