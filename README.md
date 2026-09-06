# aFIPC

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/ContextualWisdomLab/aFIPC)

**Fixed-item IRT calibration for keeping test forms on a common score scale.**

aFIPC automates fixed-item parameter calibration (FIPC) for linking and equating
workflows. It helps psychometric teams carry anchor-item information from a
reference form into calibration of a new form, inspect item-parameter drift, and
obtain linked model/score artifacts without turning the repository into a
general assessment platform.

## When aFIPC fits

Use aFIPC when you have a reference form, a newly administered form, and an
explicitly reviewed set of common items whose parameters should anchor the
linking design. The package owns the in-process calibration/linking workflow.
Test delivery, source-system data collection, operational score policy, and
downstream decision authority remain outside this repository.

The numerical implementation is compatibility-sensitive. Changes to calibration
behavior should be backed by regression evidence rather than incidental
refactoring.

## Core workflow

1. Prepare old/reference-form and new-form response data, or compatible fitted
   model objects.
2. Identify the corresponding common-item names on both forms.
3. Run `autoFIPC()` with the intended item model and explicit common-item
   confirmation.
4. Review convergence, item-parameter-drift evidence, and linked outputs before
   downstream use.

A non-interactive raw-data API shape is:

```r
result <- autoFIPC(
  newformXData = new_form,
  oldformYData = reference_form,
  newformCommonItemNames = common_new,
  oldformCommonItemNames = common_old,
  newformBILOGprior = FALSE,
  oldformBILOGprior = FALSE,
  confirmCommonItems = TRUE
)
```

The explicit BILOG-prior choices matter for the default 3PL path: leaving either
choice as `NULL` can require interactive input when raw response data are fitted.
If callers use already fitted compatible model objects, review the complete
argument contract before omitting those raw-data choices.

`autoFIPC()` returns the base-form, new-form, and linked-model artifacts as an R
list. See `man/autoFIPC.Rd` for the complete argument contract.

## Methodological boundary

`autoFIPC()` implements FIPC: common items keep reference-form parameter values
while the new form is calibrated onto that scale (Kim, 2006). This differs from
separate calibration followed by Stocking-Lord or Haebara characteristic-curve
transformations, and from concurrent calibration. aFIPC does not estimate
Stocking-Lord or Haebara linking constants.

The current estimation path delegates IRT estimation to `mirt` rather than
owning an independent numerical IRT engine. The accepted method decisions are
recorded in [the ADR index](docs/adr/README.md), and the verified APA records and
DOIs are maintained in [the research index](docs/papers/README.md).

Key sources include:

- Kim, S. (2006). A comparative study of IRT fixed parameter calibration
  methods. *Journal of Educational Measurement, 43*(4), 355-381.
  <https://doi.org/10.1111/j.1745-3984.2006.00021.x>
- Chalmers, R. P. (2012). mirt: A multidimensional item response theory package
  for the R environment. *Journal of Statistical Software, 48*(6), 1-29.
  <https://doi.org/10.18637/jss.v048.i06>
- Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood estimation of
  item parameters: Application of an EM algorithm. *Psychometrika, 46*(4),
  443-459. <https://doi.org/10.1007/BF02293801>

Linking quality still depends on anchor quality, model fit, calibration
assumptions, and the comparability of the forms being linked. Repository tests
and cited methodology are implementation evidence; they do not make arbitrary
forms automatically comparable.

## Evaluate the current source

This repository currently provides source rather than an immutable GitHub
release. It also has a known GPL-family runtime blocker: `DESCRIPTION` imports
`mirt`, and `rcmdcheck` does **not** install that dependency for the package under
check. Therefore this README does not present a fresh `install.packages("mirt")`
bootstrap as a commercially acceptable onboarding path.

If you are maintaining the existing legacy development environment and its
current dependency graph has already been provisioned for license-diligence or
compatibility work, the repository check itself is:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages("rcmdcheck", repos="https://cloud.r-project.org")'

R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

This is **not** a clean commercial-install recipe: `rcmdcheck` expects the
package's declared runtime dependencies, including the currently disallowed
`mirt`, to already exist. A commercially compatible clean setup is blocked until
issue #320 replaces/removes that runtime path and the final package graph is
revalidated.

The historical `packrat/` tree is retained for compatibility archaeology. Its
bootstrap is opt-in via `AFIPC_ENABLE_PACKRAT=true` and should not be treated as
the preferred dependency workflow.

## Architecture and responsibility

The runtime is single-process and fileless: callers provide in-memory R
data/model objects and receive R model artifacts. `R/aFIPC.R` owns the main
fixed-item linking workflow, while `R/surveyFA.R` contains supporting analytical
routines. Package metadata and generated reference docs live in `DESCRIPTION`,
`NAMESPACE`, and `man/`.

The current calibration engine calls the external `mirt` package for IRT
estimation and parameter/model operations. That dependency is a material runtime
boundary, not an implementation detail that the repository license can override.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the component map and maintenance
boundaries.

## Quality and change control

Repository automation covers R package checks, code/document quality,
workflow/security auditing, dependency review where the platform supports it,
and supply-chain posture. Before modifying estimation/linking logic, read
[CONTRIBUTING.md](CONTRIBUTING.md) and preserve the documented regression and
review discipline.

Current source metadata is `0.1.0`; the repository does not currently publish
GitHub Releases. A source version or passing development check is therefore not
presented as an immutable supported release.

## Commercial licensing status

**Not currently cleared for ContextualWisdomLab commercial
intake/distribution.**

`DESCRIPTION` presently declares `GPL-3 | file LICENSE`, while the runtime
directly imports `mirt`, whose current CRAN distribution is GPL-family licensed.
ContextualWisdomLab's commercial intake policy does not accept GPL/LGPL/AGPL
family software as the normal dependency baseline. The repository-authored
source grant and third-party runtime obligation are separate questions; neither
can be made policy-compliant by README wording alone.

Issue #320 owns the required source-provenance/relicensing review and replacement
of the GPL-family runtime path while preserving the actual fixed-item
calibration/linking estimand and regression behavior. Until that work is
integrated and verified, do not present this repository as Apache-2.0/MIT
cleared or commercially policy-compliant.

## Documentation

- [Public documentation home](docs/index.md) - product scope, workflow,
  architecture, and change-control entry point.
- [FIPC linking contract](docs/fixed-parameter-item-calibration.md) - what is
  fixed, what is estimated, and how the linked scale is defined.
- [Architecture decisions](docs/adr/README.md) - FIPC and estimation decisions.
- [Research sources](docs/papers/README.md) - verified methodological references
  and DOIs.
- [Architecture](ARCHITECTURE.md) - component and responsibility boundaries.
- [Generated R reference](man/autoFIPC.Rd) - `autoFIPC()` API contract.
- [Contributing](CONTRIBUTING.md) - contributor workflow and verification
  expectations.
- [.github/SECURITY.md](.github/SECURITY.md) - vulnerability-reporting guidance.
- [Ask DeepWiki](https://deepwiki.com/ContextualWisdomLab/aFIPC) -
  repository-aware navigation.

For scientific or operational changes, open an issue or pull request with the
exact design assumptions, affected calibration behavior, and reproducible
verification evidence.
