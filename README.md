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
- Program completion baseline:
  `docs/plans/2026-07-02-program-completion-baseline.md`
- Operational guardrails are now maintained via GitHub Actions and Dependabot.
- `surveyFA()` fallback now uses a bounded `mirt`-native recovery path that
  attempts alternate estimators and bounded item removal before failing.
- Legacy `packrat` bootstrap is opt-in via `AFIPC_ENABLE_PACKRAT=true`.
- Broken host-specific `packrat/lib-R` symlinks were removed for portable builds.
- `ContextualWisdomLab` 운영팀 판매판단 체크리스트:
  - 정합한 `R` 실행환경 + `R CMD check --as-cran` 통과
  - `autoFIPC()`의 비인터랙티브 실행에서 명확한 종료 동작
  - `surveyFA()`의 bounded 재추정 시도(대체 추정기 + bounded item 제거)
  - 복구 불가 시 명시적 실패 메시지(`surveyFA fallback could not estimate ...`)
  - 회귀 고정 테스트(`tests/testthat/test-surveyFA.R`)의 신규/기존 항목 통과
- KRW 2B technical sale-readiness diligence pack:
  `docs/commercial/2026-07-02-krw-2b-sale-readiness.md`
- Plugin-driven KRW 2B sale-readiness execution plan:
  `docs/commercial/2026-07-02-plugin-sale-readiness-plan.md`
- Reproducible sale-readiness verification evidence:
  `docs/validation/2026-07-02-sale-readiness-evidence.md`
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
R_PROFILE_USER=/dev/null Rscript scripts/validate-sale-readiness.R
```

Lower-level checks:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages(c("pkgload", "testthat", "rcmdcheck"), repos="https://cloud.r-project.org")'
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

## Maintenance policy

- Prefer preserving equation/calibration behavior over refactoring.
- Avoid silent behavioral changes in `autoFIPC()` without explicit regression
  evidence.
- Keep CI green on supported runners and keep Actions pinned/updated.
