# aFIPC

Automated Fixed Item Parameter Calibration (FIPC) for IRT test linking.

This package contains the original graduate-school implementation used to
produce accurate fixed-item linking results. The current maintenance goal is to
preserve numerical behavior while modernizing repository operations
(documentation, CI, and dependency hygiene).

## Methodological sources

`autoFIPC()` implements fixed item parameter calibration (FIPC): common
items keep their old-form parameter values while the new form is
calibrated onto that scale (Kim, 2006). That is a different design from
separate calibration plus a Stocking and Lord (1983) or Haebara (1980)
characteristic-curve transformation, and from concurrent calibration
(Kolen & Brennan, 2014). This package does not estimate Stocking–Lord
or Haebara linking constants.

Estimation is delegated to `mirt` MML-EM (Chalmers, 2012; Bock &
Aitkin, 1981). Linked-score interpretation is bounded by AERA, APA, and
NCME (2014). Full APA records and DOIs are in
`docs/papers/README.md`; method decisions are in `docs/adr/`.

Kim, S. (2006). A comparative study of IRT fixed parameter calibration
methods. *Journal of Educational Measurement, 43*(4), 355–381.
<https://doi.org/10.1111/j.1745-3984.2006.00021.x>

Stocking, M. L., & Lord, F. M. (1983). Developing a common metric in
item response theory. *Applied Psychological Measurement, 7*(2),
201–210. <https://doi.org/10.1177/014662168300700208>

Haebara, T. (1980). Equating logistic ability scales by a weighted
least squares method. *Japanese Psychological Research, 22*(3),
144–149. <https://doi.org/10.4992/psycholres1954.22.144>

Kolen, M. J., & Brennan, R. L. (2014). *Test equating, scaling, and
linking: Methods and practices* (3rd ed.). Springer.
<https://doi.org/10.1007/978-1-4939-0317-7>

Chalmers, R. P. (2012). mirt: A multidimensional item response theory
package for the R environment. *Journal of Statistical Software,
48*(6), 1–29. <https://doi.org/10.18637/jss.v048.i06>

Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood
estimation of item parameters: Application of an EM algorithm.
*Psychometrika, 46*(4), 443–459.
<https://doi.org/10.1007/BF02293801>

American Educational Research Association, American Psychological
Association, & National Council on Measurement in Education. (2014).
*Standards for educational and psychological testing*. American
Educational Research Association.

## What this repository contains

- `R/aFIPC.R`: core `autoFIPC()` implementation
- `DESCRIPTION`, `NAMESPACE`, `man/`: package metadata and generated docs
- `docs/adr/`: architecture decision records for FIPC and estimation
- `docs/fixed-parameter-item-calibration.md`: linking-contract restatement
- `docs/papers/README.md`: verified source papers and DOIs
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
- Avoid silent behavioral changes in `autoFIPC()` without explicit regression
  evidence.
- Keep CI green on supported runners and keep Actions pinned/updated.
