# AGENTS.md

## Scope

This repository contains the aFIPC R package and its supporting documentation,
CI, security, and historical dependency material. Preserve scientific behavior
unless a change is backed by explicit regression evidence.

## Repository priorities

1. Preserve fixed-item calibration semantics and historical numerical behavior.
2. Keep security, package checks, and documentation truthful and reproducible.
3. Prefer small, auditable changes over broad refactors.
4. Keep generated/package metadata consistent with source and documentation.

## Source boundaries

- `R/aFIPC.R` owns the main `autoFIPC()` orchestration flow.
- `R/surveyFA.R` contains supporting analytical recovery routines.
- `DESCRIPTION`, `NAMESPACE`, and `man/` are R package surfaces.
- `docs/adr/` records accepted method/architecture decisions.
- `docs/papers/README.md` records verified methodological sources.
- `packrat/` is historical compatibility material, not the preferred dependency
  workflow.

Do not silently alter common-item matching, fixed/free parameter semantics,
latent-distribution handling, IPD/DIF screening, estimation method selection,
scoring, or expected-score output.

## Change discipline

- Treat `R/aFIPC.R` numerical behavior as compatibility-sensitive.
- Add focused regression evidence before intentional scientific behavior changes.
- Keep input validation and fail-closed behavior intact unless a stronger
  evidence-backed contract replaces it.
- Do not replace a failing check with a weaker threshold or exclusion.
- Do not invent release, benchmark, customer, certification, or commercial
  readiness claims from local or predecessor evidence.

## Validation

Run the repository's actual package/documentation checks. The canonical local R
package check is:

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'install.packages("rcmdcheck", repos="https://cloud.r-project.org")'
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")'
```

Hosted exact-head checks remain authoritative for merge decisions. A push
invalidates predecessor-head check and review evidence.

## Commercial license boundary

The repository currently declares GPL-family package/runtime licensing and
imports `mirt`. Do not present the source as Apache-2.0/MIT-cleared or
commercially intake-compliant until the provenance/relicensing and dependency
replacement work tracked by issue #320 is integrated and verified. Repository
source licensing and third-party dependency licensing are separate obligations.

<!-- BEGIN cwl-agent-guidance -->
## ContextualWisdomLab operating context

- Keep this component independently usable and composable. A sibling repository
  may consume it through a released/versioned boundary, but do not create hidden
  cross-repository implementation coupling.
- Sibling components include `fast-mlsirm`, which may consume aFIPC-style
  fixed-item calibration concepts in broader psychometric workflows. aFIPC does
  not become the owner of those sibling products' orchestration, data, or
  deployment authority.
- Cross-product LLM/provider routing, if ever required, belongs to
  `contextual-orchestrator`, not this numerical R package.

### Research grounding

- For substantive calibration/linking changes, cite the relevant IRT and
  psychometrics literature. Commit paper PDFs only when redistribution is
  permitted; otherwise cite, link, and summarize.
- Method decisions are recorded in `docs/adr/`. Verified APA 7th records and
  DOIs are in `docs/papers/README.md`. Do not invent bibliographic records or
  leave empty `DOI:` placeholders.
- The implemented linking contract is FIPC (Kim, 2006): anchors keep old-form
  values. `autoFIPC()` does not estimate a Stocking-Lord (1983) or Haebara
  (1980) transformation (ADR-0001).
- `mirt` owns numerical estimation (ADR-0002), but do not flatten all returned
  models into one method label. Raw old/new data fits can recover through QMCEM,
  MHRM, and `surveyFA` paths when an initial fit is unacceptable. The linked
  FIPC fit and IPD/DIF path use EM for nominal items or `tryEM = TRUE`, and MHRM
  otherwise. Record the actual method path when evidence depends on it.
- IPD/DIF screening is delegated to `mirt` and is not a published invariance
  claim (ADR-0003).
- Do not restore the earlier incorrect attribution of "Linking item parameters
  to a base scale" to Kim and Kolen (2010) in the *Journal of Educational
  Measurement*. The title belongs to Kang and Petersen (2012). Kim and Kolen
  (2019) is a separate, real FIPC application paper.
<!-- END cwl-agent-guidance -->
