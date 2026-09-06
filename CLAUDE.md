# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

<!-- markdownlint-configure-file { "MD013": { "line_length": 120 } } -->

**`AGENTS.md` is the canonical agent operating guide for this repository.**
Read it first and follow its guardrails before making changes; this file
summarizes essentials and does not override it.

## What this package is

`aFIPC` is an R package that automates Fixed Item Parameter Calibration
(FIPC) for IRT test linking, built on `mirt`. The algorithmic core is the
original graduate-school implementation; the maintenance goal is to preserve
its historical numerical behavior while modernizing repository operations
(documentation, CI, dependency hygiene).

## Common commands

Run all commands from the repository root. `R_PROFILE_USER=/dev/null`
bypasses the legacy packrat autoloader in `.Rprofile` (packrat is opt-in via
`AFIPC_ENABLE_PACKRAT=true`).

Full package check (canonical local verification, mirrors the `r.yml` CI):

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages(c("rcmdcheck"), repos="https://cloud.r-project.org")'
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

Test suite only (testthat edition 3, see `Config/testthat/edition` in
`DESCRIPTION`):

```bash
R_PROFILE_USER=/dev/null Rscript -e 'testthat::test_local()'
```

Single test file (`filter` matches `tests/testthat/test-<filter>.R`):

```bash
R_PROFILE_USER=/dev/null Rscript -e 'testthat::test_local(filter = "surveyFA")'
```

Regenerate docs (`man/` and `NAMESPACE` are roxygen2-generated; never edit
them by hand):

```bash
R_PROFILE_USER=/dev/null Rscript -e 'roxygen2::roxygenise()'
```

Lint checks that CI (`code-quality.yml`) enforces — this file itself is
markdown-linted:

```bash
python3 -m yamllint .yamllint.yml .github/dependabot.yml \
  .github/workflows/*.yml
markdownlint-cli2 README.md AGENTS.md ARCHITECTURE.md CLAUDE.md \
  CONTRIBUTING.md .github/**/*.md docs/**/*.md
```

## Architecture

See `ARCHITECTURE.md` for the full map. Essentials:

- `R/aFIPC.R` — core `autoFIPC()` implementation (~1,070 lines of legacy
  calibration + linking logic with interactive prompts). **High risk**:
  changes here can alter scientific output.
- `R/surveyFA.R` — `surveyFA()`, the fallback calibration helper used when
  direct model estimation in `autoFIPC()` fails.
- Exported API (`NAMESPACE`): `autoFIPC()` and `surveyFA()`; the package
  imports `mirt` and `methods` (`DESCRIPTION`).
- `man/` — generated `.Rd` docs for the exported functions.
- `tests/testthat/` — testthat suite, driven by `tests/testthat.R`.
- `packrat/` — historical vendored dependency tree; opt-in only.
- `.github/workflows/` — `r.yml` (R CMD check), `code-quality.yml`
  (yamllint + markdownlint + actionlint), `security-audit.yml` (gitleaks +
  actionlint). All action refs are pinned to full commit SHAs.

Runtime is single-process and fileless: in-memory old/new form data ->
`autoFIPC()` -> `mirt` calibration -> optional item parameter drift (IPD)
check -> fixed common-item constraints -> linked model plus expected
score/theta outputs, returned as an R list.

The linking contract (Kim, 2006): anchor items keep their old-form parameter
values fixed during new-form calibration so the new form is calibrated
directly onto the established scale. It is documented in
`docs/fixed-parameter-item-calibration.md` and enforced by
`tests/testthat/test-fixed-parameter-calibration.R`.

## Key conventions

Summarized from `AGENTS.md` and `CONTRIBUTING.md`; read those for detail.

- Preserve historical numerical behavior in `R/aFIPC.R` unless there is
  explicit regression evidence and maintainer intent to change behavior.
  Add tests/fixtures first when behavior changes are required.
- Keep changes minimal and auditable; prefer additive guardrails over broad
  refactoring, and isolate operational fixes from algorithmic edits.
- `tests/testthat/test-optimization-equivalence.R` pins formula-bearing
  expressions with hand-computed reference values; performance refactors
  must not change their meaning.
- `autoFIPC()` requires explicit common-item confirmation: pass
  `confirmCommonItems = TRUE` in non-interactive contexts (the tests assert
  that implicit approval fails).
- A failing `trivy-fs` in the Security Scan gate is a real finding, not a
  flake: bump the offending vendored dependency under `packrat/`, or add a
  narrow, path-scoped, commented entry to `.trivyignore.yaml`. Never weaken
  the gate. (`trivy.yaml` skips `packrat/lib` for local scans.)
- New copyleft dependencies (GPL/AGPL/LGPL) are not accepted; never commit
  secrets.
- Use the PR template (`.github/PULL_REQUEST_TEMPLATE.md`): include risk
  notes and verification evidence, and keep new/updated GitHub Actions
  pinned to full commit SHAs.
- For substantive calibration/linking changes, cite the relevant IRT and
  psychometrics literature (see "Research grounding" in `AGENTS.md`).

## Further reading

- `ARCHITECTURE.md` — structure map, CI wiring, security posture, roadmap
- `CONTRIBUTING.md` — contribution process and verification baseline
- `docs/operations/maintenance-runbook.md` — recurring maintainer operations
- `docs/fixed-parameter-item-calibration.md` — calibration/linking basis
