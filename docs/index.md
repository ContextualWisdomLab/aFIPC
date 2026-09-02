# aFIPC

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/ContextualWisdomLab/aFIPC)

Automated Fixed Item Parameter Calibration for item-response-theory linking and
equating.

## Product responsibility

aFIPC preserves a common measurement scale across test forms by combining
anchor-item information from a reference form with calibration of newly
administered items. It is intended for psychometric workflows where score
comparability across administrations matters and fixed-item linking is the
chosen design.

The repository owns the in-process R calibration/linking workflow. Test
delivery, source-system data collection, operational score policy, and
downstream decision authority remain outside this package.

## Core workflow

1. Prepare reference-form and new-form response data or compatible fitted model
   objects.
2. Define the reviewed common-item correspondence between forms.
3. Run `autoFIPC()` with the intended item model and explicit common-item
   confirmation.
4. Review convergence, item-parameter-drift evidence, and linked outputs before
   downstream score reporting or operational use.

## Method and architecture

- `R/aFIPC.R` contains the main fixed-item linking workflow.
- `R/surveyFA.R` contains supporting analytical routines used by the package.
- `DESCRIPTION`, `NAMESPACE`, and `man/` define package metadata and generated
  reference documentation.
- `docs/adr/` records reviewed method/architecture decisions.
- `docs/papers/` retains verified methodological references and DOIs.
- `.github/workflows/` provides continuous-integration and security checks.

The current calibration engine directly uses the external `mirt` runtime for
IRT estimation and parameter/model operations. FIPC is distinct from separate
calibration plus Stocking-Lord/Haebara transformations and from concurrent
calibration. See the FIPC contract and ADR index for the precise boundary.

## Onboarding and verification

Clone the repository, use a current R toolchain, and run the package checks
before changing calibration behavior:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages("rcmdcheck", repos="https://cloud.r-project.org")'
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

For contributor expectations and architectural context, read `CONTRIBUTING.md`
and `ARCHITECTURE.md` before modifying estimation or linking logic.

## Release and commercial-license status

The repository currently has no published GitHub Release. Source metadata
`0.1.0` and development checks are not immutable release evidence.

The current source/dependency graph is also **not cleared for
ContextualWisdomLab commercial intake/distribution**: package metadata declares
`GPL-3 | file LICENSE`, and the runtime directly imports the GPL-family `mirt`
package. Issue #320 owns the source-provenance/relicensing review plus
replacement of that runtime dependency while preserving the actual fixed-item
calibration/linking contract. Until that work is complete, do not describe
aFIPC as Apache-2.0/MIT-cleared or commercially policy-compliant.

## Documentation and support

- [Repository README](https://github.com/ContextualWisdomLab/aFIPC/blob/master/README.md)
  - product, usage, status, and contributor entry point.
- [Architecture](https://github.com/ContextualWisdomLab/aFIPC/blob/master/ARCHITECTURE.md)
  - runtime and maintenance boundaries.
- [FIPC linking contract](fixed-parameter-item-calibration.md) - linking design.
- [Architecture decisions](adr/README.md) - method and ownership decisions.
- [Research sources](papers/README.md) - verified references and DOIs.
- [Contributing](https://github.com/ContextualWisdomLab/aFIPC/blob/master/CONTRIBUTING.md)
  - development and verification expectations.
- [Ask DeepWiki](https://deepwiki.com/ContextualWisdomLab/aFIPC) - repository-aware
  documentation and code navigation.

Linking quality depends on anchor quality, model fit, calibration assumptions,
and the comparability of the forms being linked. Repository tests and cited
methodology are implementation evidence; they do not make arbitrary test forms
automatically comparable.

This file is a Pages-ready source only. It is not evidence that GitHub Pages is
published; publication requires repository settings and live HTTPS verification.
