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
linking design. The package is intentionally focused: it owns the in-process
calibration/linking workflow, while data collection, operational test delivery,
reporting policy, and downstream score-use decisions remain outside this
repository.

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

A minimal API shape is:

```r
result <- autoFIPC(
  newformXData = new_form,
  oldformYData = reference_form,
  newformCommonItemNames = common_new,
  oldformCommonItemNames = common_old,
  confirmCommonItems = TRUE
)
```

`autoFIPC()` returns the base-form, new-form, and linked-model artifacts as an R
list. See `man/autoFIPC.Rd` for the complete argument contract.

## Evaluate from source

This repository currently provides a source package rather than a published
GitHub release. For contributor/evaluation checks, use a clean R profile and the
same `rcmdcheck` path exercised by repository automation:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages("rcmdcheck", repos="https://cloud.r-project.org")'

R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

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
family software as the normal dependency baseline. The root repository grant
and the third-party runtime obligation are separate issues; neither can be made
policy-compliant by README wording alone.

Issue #320 owns the required provenance/relicensing review and replacement of
the GPL-family runtime path while preserving the actual fixed-item
calibration/linking estimand and regression behavior. Until that work is
integrated and verified, do not present this repository as Apache-2.0/MIT
cleared or commercially policy-compliant.

## Documentation

- [Public documentation home](docs/index.md) — product scope, workflow,
  architecture, and change-control entry point.
- [Architecture](ARCHITECTURE.md) — component and responsibility boundaries.
- [Generated R reference](man/autoFIPC.Rd) — `autoFIPC()` API contract.
- [Contributing](CONTRIBUTING.md) — contributor workflow and verification
  expectations.
- [.github/SECURITY.md](.github/SECURITY.md) — repository
  vulnerability-reporting guidance.
- [Ask DeepWiki](https://deepwiki.com/ContextualWisdomLab/aFIPC) —
  repository-aware navigation.

For scientific or operational changes, open an issue or pull request with the
exact design assumptions, affected calibration behavior, and reproducible
verification evidence.
