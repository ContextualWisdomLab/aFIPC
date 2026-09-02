# aFIPC

Automated Fixed Item Parameter Calibration for item-response-theory linking and equating.

## Product responsibility

aFIPC preserves a common measurement scale across test forms by combining anchor-item information from a reference form with calibration of newly administered items. It is intended for psychometric workflows where score comparability across administrations matters and fixed-item linking is the chosen design.

The repository owns the in-process R calibration/linking workflow. Test delivery, source-system data collection, operational score policy, and downstream decision authority remain outside this package.

## Core workflow

1. Prepare reference-form and new-form response data or compatible fitted model objects.
2. Define the reviewed common-item correspondence between forms.
3. Run `autoFIPC()` with the intended item model and explicit common-item confirmation.
4. Review convergence, item-parameter-drift evidence, and linked outputs before downstream score reporting or operational use.

## Architecture

The repository is a focused R package:

- `R/aFIPC.R` contains the main fixed-item linking workflow.
- `R/surveyFA.R` contains supporting analytical routines used by the package.
- `DESCRIPTION`, `NAMESPACE`, and `man/` define package metadata and generated reference documentation.
- `ARCHITECTURE.md` documents structural boundaries and maintenance constraints.
- `.github/workflows/` provides continuous-integration and security checks.

The current calibration engine directly uses the external `mirt` runtime for IRT estimation and parameter/model operations. Numerical behavior is compatibility-sensitive; behavioral changes should be supported by regression evidence rather than incidental refactoring.

## Onboarding and verification

Clone the repository, use a current R toolchain, and run the package checks before changing calibration behavior:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages("rcmdcheck", repos="https://cloud.r-project.org")'
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

For contributor expectations and architectural context, read the repository's `CONTRIBUTING.md` and `ARCHITECTURE.md` before modifying estimation or linking logic.

## Release and commercial-license status

The repository currently has no published GitHub Release. Source metadata `0.1.0` and development checks are not immutable release evidence.

The current source/dependency graph is also **not cleared for ContextualWisdomLab commercial intake/distribution**: package metadata declares `GPL-3 | file LICENSE`, and the runtime directly imports the GPL-family `mirt` package. Issue #320 owns provenance/relicensing review plus replacement of that runtime dependency while preserving the actual fixed-item calibration/linking contract. Until that work is complete, do not describe aFIPC as Apache-2.0/MIT-cleared or commercially policy-compliant.

## Documentation and support

- Repository README: product, usage, status, and contributor entry point.
- `ARCHITECTURE.md`: package boundaries and design context.
- `man/autoFIPC.Rd`: generated `autoFIPC()` reference.
- `CONTRIBUTING.md`: contributor and verification expectations.
- `.github/SECURITY.md`: vulnerability-reporting guidance.
- [Ask DeepWiki](https://deepwiki.com/ContextualWisdomLab/aFIPC): repository-aware documentation and code navigation.
