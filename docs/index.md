# aFIPC

Automated Fixed Item Parameter Calibration for item-response-theory linking and equating.

## Product responsibility

aFIPC preserves a common measurement scale across test forms by combining anchor-item parameters from a reference form with calibration of newly administered items. It is intended for psychometric workflows where score comparability across administrations matters and fixed-item linking is the chosen design.

## Core workflow

1. Prepare reference-form and new-form response data with a stable set of common items.
2. Fit or supply the reference-form item parameters used as linking anchors.
3. Run `autoFIPC()` to construct the fixed-item calibration workflow for the new form.
4. Review model diagnostics and linking outputs before downstream score reporting or operational use.

## Architecture

The repository is an R package with a focused calibration core:

- `R/aFIPC.R` contains the main fixed-item linking workflow.
- `R/surveyFA.R` contains supporting analytical routines used by the package.
- `DESCRIPTION`, `NAMESPACE`, and `man/` define package metadata and generated reference documentation.
- `ARCHITECTURE.md` documents structural boundaries and maintenance constraints.
- `.github/workflows/` provides continuous-integration and security checks.

The package keeps established numerical behavior as a compatibility constraint; behavioral changes should be supported by regression evidence rather than incidental refactoring.

## Onboarding

Clone the repository, use a current R toolchain, and run the package checks before changing calibration behavior:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages(c("rcmdcheck"), repos="https://cloud.r-project.org")'
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

For contributor expectations and architectural context, read `CONTRIBUTING.md` and `ARCHITECTURE.md` before modifying estimation or linking logic.

## Releases and change control

The repository currently does not publish GitHub Releases. Until a tagged release is available, consumers should pin an explicitly tested commit or package build and review the repository history for behavioral changes. Calibration changes should preserve reproducibility and be accompanied by test evidence.

## Documentation and support

- Repository README: concise product and contributor entry point.
- `ARCHITECTURE.md`: package boundaries and design context.
- `man/`: generated R reference documentation.
- [Ask DeepWiki](https://deepwiki.com/ContextualWisdomLab/aFIPC): repository-aware documentation and code navigation.
