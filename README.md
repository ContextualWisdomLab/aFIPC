# aFIPC

Automated Fixed Item Parameter Calibration (FIPC) for IRT test linking.

This package contains the original graduate-school implementation used to
produce accurate fixed-item linking results. The current maintenance goal is to
preserve numerical behavior while modernizing repository operations
(documentation, CI, and dependency hygiene).

## What this repository contains

- `R/aFIPC.R`: core `autoFIPC()` implementation
- `DESCRIPTION`, `NAMESPACE`, `man/`: package metadata and generated docs
- `packrat/`: historical dependency lock/vendor directory
- `.github/workflows/`: CI/security automation

## Development status

- Algorithmic core is legacy but trusted for historical outputs.
- Operational guardrails are now maintained via GitHub Actions and Dependabot.
- Legacy `packrat` bootstrap is opt-in via `AFIPC_ENABLE_PACKRAT=true`.
- Broken host-specific `packrat/lib-R` symlinks were removed for portable builds.
- Architectural and agent operation docs are available in:
  - `ARCHITECTURE.md`
  - `AGENTS.md`
  - `CLAUDE.md`
  - `CONTRIBUTING.md`
  - `.github/SECURITY.md`

## Local package check

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages(c("rcmdcheck"), repos="https://cloud.r-project.org")'
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

## Maintenance policy

- Prefer preserving equation/calibration behavior over refactoring.
- Avoid silent behavioral changes in `autoFIPC()` without explicit regression
  evidence.
- Keep CI green on supported runners and keep Actions pinned/updated.
