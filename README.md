# aFIPC

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/ContextualWisdomLab/aFIPC)

Automated Fixed Item Parameter Calibration (FIPC) for IRT test linking and equating. aFIPC helps psychometric teams preserve score-scale continuity across test forms by fixing anchor-item parameters while estimating parameters for newly administered items.

## What this repository contains

- `R/aFIPC.R`: core `autoFIPC()` implementation
- `DESCRIPTION`, `NAMESPACE`, `man/`: package metadata and generated docs
- `packrat/`: historical dependency lock/vendor directory
- `.github/workflows/`: CI/security automation
- `docs/index.md`: product, architecture, onboarding, and release-facing documentation

## Development status

- Algorithmic behavior is preserved for compatibility with established linking outputs.
- Operational guardrails are maintained via GitHub Actions and Dependabot.
- Legacy `packrat` bootstrap is opt-in via `AFIPC_ENABLE_PACKRAT=true`.
- Broken host-specific `packrat/lib-R` symlinks were removed for portable builds.
- Architectural and agent operation docs are available in:
  - `ARCHITECTURE.md`
  - `AGENTS.md`
  - `CLAUDE.md`
  - `CONTRIBUTING.md`
  - `.github/SECURITY.md`

## Collaboration workflow

- Pull request template: `.github/PULL_REQUEST_TEMPLATE.md`
- Issue templates: `.github/ISSUE_TEMPLATE/`
- Code ownership: `.github/CODEOWNERS`
- Code quality checks: `.github/workflows/code-quality.yml`
- Security checks (private-safe): `.github/workflows/security-audit.yml`
- Secret-scan policy config: `.gitleaks.toml`
- CodeRabbit command reference: `docs/coderabbit/review-commands.md`
- Maintainer operations runbook: `docs/operations/maintenance-runbook.md`

## Local package check

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages(c("rcmdcheck"), repos="https://cloud.r-project.org")'
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

## Maintenance policy

- Prefer preserving equation/calibration behavior over refactoring.
- Avoid silent behavioral changes in `autoFIPC()` without explicit regression evidence.
- Keep CI green on supported runners and keep Actions pinned/updated.
