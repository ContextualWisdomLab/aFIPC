# Contributing Guide

Thank you for contributing to `aFIPC`.

This repository prioritizes reproducibility and historical numerical stability
over feature velocity.

## Ground Rules

1. Avoid behavior changes in `R/aFIPC.R` unless backed by explicit regression
   evidence and maintainer approval.
2. Prefer small, auditable pull requests.
3. Keep CI/security/docs healthy (`.github/workflows/`, `README.md`,
   `ARCHITECTURE.md`, `AGENTS.md`).

## Development Setup

1. Clone the repository.
2. Ensure R is installed.
3. Install check tooling:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages(c("rcmdcheck"), repos="https://cloud.r-project.org")'
```

## Local Verification

Run package checks before opening a pull request:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

If this fails due to legacy `packrat` bootstrap behavior, document the failure
in your PR and rely on CI workflow output for reproducible evidence.

## Pull Request Expectations

- Describe what changed and why.
- Include risk notes, especially for calibration/linking logic.
- Include verification evidence (commands + result summary).
- Keep action references pinned to commit SHAs in workflow files.

## Security and Dependency Policy

- Do not commit secrets (`.env`, keys, credentials).
- Copyleft dependencies (GPL/AGPL/LGPL) are not accepted as new additions.
- Use Dependabot and dependency review checks as required gates.
