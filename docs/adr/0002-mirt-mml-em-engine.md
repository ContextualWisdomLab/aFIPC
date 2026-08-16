# ADR-0002: mirt MML-EM as the estimation engine

- Status: Accepted
- Date: 2026-08-16
- Deciders: maintainers

## Context

FIPC (ADR-0001) is a linking contract: which parameters are copied from
the old form and held fixed. Someone still has to estimate the free
item parameters and the ability distribution. This package is an R
orchestrator, not a new IRT estimator.

Chalmers (2012) describes `mirt`, the package `DESCRIPTION` imports.
Bock and Aitkin (1981) give the marginal maximum likelihood EM
(MML-EM) algorithm that `mirt` implements when `method = "EM"`.
`autoFIPC()` uses that path when `tryEM` is true (the default) or when
the item type is nominal.

## Decision

Use `mirt` as the estimation engine and MML-EM as the default
calibration method:

- Separate old-form and new-form fits call `mirt::mirt`.
- The linked fit calls `mirt::mirt` with `pars` after the FIPC
  copy-and-fix step.
- Default linked estimation uses `method = "EM"` (Bock & Aitkin,
  1981, as implemented by Chalmers, 2012).
- Scores and expected-score artifacts use `mirt` helpers such as
  `fscores` and `expected.test`.

This package does not reimplement the likelihood, quadrature, or EM
cycles.

## Alternatives considered

- **A custom MML-EM implementation in `R/aFIPC.R`.** Would duplicate
  a maintained estimator and risk silent numerical drift. Rejected.
- **A different IRT package.** Historical outputs were produced with
  `mirt`. Changing engines would be a scientific behavior change, not
  a docs fix.
- **`mirt` MHRM (`method = "MHRM"`).** `autoFIPC()` can take this
  path when `tryEM` is false and the item type is not nominal. It is
  an optional `mirt` method, not the default FIPC engine documented
  here.

## Consequences

- Numerical changes in `mirt` can change `autoFIPC()` output even when
  this repository's R sources are untouched.
- Formula-integrity reviews (see
  `docs/fixed-parameter-item-calibration.md`) apply to orchestration
  only. Estimation mathematics stay in `mirt`.
- `man/autoFIPC.Rd` remains roxygen-generated from `R/aFIPC.R`.
  Method citations belong in these markdown ADRs and
  `docs/papers/README.md` unless the roxygen `@references` block is
  updated in the same change.

## Claim boundary

Choosing `mirt` and MML-EM is an engineering dependency decision. It
is not a claim that this package contributes a new estimation
algorithm, and it is not a claim about the relative accuracy of EM
versus other `mirt` methods. Linking-scale interpretation remains
bounded by ADR-0001 and AERA/APA/NCME (2014).

## References

Chalmers, R. P. (2012). mirt: A multidimensional item response theory
package for the R environment. *Journal of Statistical Software,
48*(6), 1–29. <https://doi.org/10.18637/jss.v048.i06>

Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood
estimation of item parameters: Application of an EM algorithm.
*Psychometrika, 46*(4), 443–459.
<https://doi.org/10.1007/BF02293801>

Kim, S. (2006). A comparative study of IRT fixed parameter calibration
methods. *Journal of Educational Measurement, 43*(4), 355–381.
<https://doi.org/10.1111/j.1745-3984.2006.00021.x>
