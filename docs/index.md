# aFIPC

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/ContextualWisdomLab/aFIPC)

**aFIPC** provides automated Fixed Item Parameter Calibration (FIPC) for item-response-theory test linking. It preserves common-item parameters from an old form while calibrating new-form items onto the established scale, with estimation delegated to `mirt`.

## Product scope

- `autoFIPC()` implements the package's FIPC linking workflow.
- Common items retain old-form parameter values during linked calibration.
- The package uses `mirt` marginal maximum-likelihood / EM estimation rather than implementing a separate numerical IRT engine.
- FIPC is intentionally distinct from separate calibration followed by Stocking–Lord or Haebara characteristic-curve transformations and from concurrent calibration.
- Item-parameter-drift / DIF screening is delegated to the supported `mirt` machinery documented by the repository.

## Start here

Install or inspect the package from the organization-owned repository:

```r
# install.packages("remotes")
remotes::install_github("ContextualWisdomLab/aFIPC")
```

For local development and verification, follow the repository README and contribution guidance rather than relying on the historical vendored Packrat installation tree.

## Documentation

- [Repository README](https://github.com/ContextualWisdomLab/aFIPC/blob/master/README.md) — package purpose, development status, and local package checks.
- [Architecture](https://github.com/ContextualWisdomLab/aFIPC/blob/master/ARCHITECTURE.md) — runtime and maintenance boundaries.
- [FIPC linking contract](fixed-parameter-item-calibration.md) — what is fixed, what is estimated, and how the linked scale is defined.
- [Architecture decisions](adr/) — reviewed decisions for FIPC-only linking, `mirt` MML-EM estimation, and IPD/DIF delegation.
- [Research sources](papers/) — verified methodological references and DOIs.
- [Contributing](https://github.com/ContextualWisdomLab/aFIPC/blob/master/CONTRIBUTING.md) — development and verification expectations.
- [GitHub Releases](https://github.com/ContextualWisdomLab/aFIPC/releases) — release history when available.
- [Ask DeepWiki](https://deepwiki.com/ContextualWisdomLab/aFIPC) — repository-aware questions about the code and documentation.

## Evidence boundary

aFIPC is psychometric research software. Linking quality depends on anchor quality, model fit, calibration assumptions, and the comparability of the forms being linked. Repository tests and cited methodology provide implementation evidence; they do not make every pair of operational test forms automatically comparable.

This page is suitable as the source for a minimal GitHub Pages site once the organization-owned metadata/Pages reconciler can publish the repository safely. A source commit alone is not evidence that Pages is live.
