# ADR-0002: mirt as the estimation engine

- Status: Accepted
- Date: 2026-08-16
- Deciders: maintainers

## Context

FIPC (ADR-0001) is a linking contract: which parameters are copied from
the old form and held fixed. Someone still has to estimate the free
item parameters and the ability distribution. This package is an R
orchestrator, not a new IRT estimator.

Chalmers (2012) describes `mirt`, the package `DESCRIPTION` imports.
Bock and Aitkin (1981) give the marginal maximum-likelihood EM
(MML-EM) basis used when `mirt` is called with `method = "EM"`.

The implementation does not use one estimation method for every model
artifact. The method policy has three distinct stages:

1. When raw old/new form data must first be fitted, `autoFIPC()` starts with
   the ordinary `mirt` path. If the current fit is still unacceptable and the
   corresponding `tryFitwholeOldItems` or `tryFitwholeNewItems` flag is true,
   that flag gates only the direct QMCEM retry followed by the direct MHRM
   retry. If the model remains unacceptable after that stage—or if the direct
   whole-form retry flag is false—the later `surveyFA()` recovery sequence is
   still evaluated independently: `forceUIRT`, then `forceNormalEM`, then the
   `unstable` path, then `forceMHRM`, with each later step attempted only while
   the current model remains unacceptable. These raw-form recovery gates are
   independent of the later linked-fit `tryEM` choice.
2. The linked FIPC fit uses EM when `itemtype == "nominal"` or `tryEM` is
   true. Otherwise it uses MHRM.
3. IPD/DIF screening follows the same EM-versus-MHRM selection rule as the
   linked fit: EM for nominal items or `tryEM = TRUE`, MHRM otherwise.

Accordingly, an `autoFIPC()` result can legitimately contain old/new form
models fitted by QMCEM, MHRM, or a `surveyFA()` recovery path even when the
linked model uses EM. Setting `tryFitwholeOldItems = FALSE` or
`tryFitwholeNewItems = FALSE` suppresses only the corresponding direct
QMCEM/MHRM whole-form retries; it does not suppress later `surveyFA()` recovery.
Documentation must not label every returned model as MML-EM.

## Decision

Use `mirt` as the estimation engine while keeping the method of each model
artifact explicit:

- Separate old-form and new-form raw-data fits call `mirt::mirt`. Their
  `tryFitwhole*` flags gate the direct QMCEM-then-MHRM retries only; if the
  current model is still unacceptable, `surveyFA()` recovery remains a
  separate subsequent gate sequence.
- The linked fit calls `mirt::mirt` with `pars` after the FIPC copy-and-fix
  step.
- Default linked estimation uses `method = "EM"` because `tryEM` defaults to
  true; non-nominal linked estimation uses `method = "MHRM"` when
  `tryEM = FALSE`.
- IPD/DIF uses `mirt::multipleGroup` and `mirt::DIF` with the same explicit
  EM/MHRM branch.
- Scores and expected-score artifacts use `mirt` helpers such as `fscores`
  and `expected.test`.

This package does not reimplement the likelihood, quadrature, EM, QMCEM, or
MHRM algorithms.

## Alternatives considered

- **A custom estimator in `R/aFIPC.R`.** This would duplicate a maintained
  estimator and risk silent numerical drift. Rejected.
- **A different IRT package.** Historical outputs were produced with `mirt`.
  Changing engines would be a scientific behavior change, not a docs fix.
- **Treating `tryFitwhole* = FALSE` as disabling every later recovery.**
  Rejected because current source places the `surveyFA()` recovery sequence
  outside those direct retry gates.
- **Calling every result “MML-EM.”** Rejected because source permits QMCEM and
  MHRM for raw-form recovery and MHRM for the linked/IPD branch when the
  explicit method policy selects it.

## Consequences

- Numerical changes in `mirt` can change `autoFIPC()` output even when this
  repository's R sources are untouched.
- Evidence about a returned model should record its actual estimation path;
  `tryEM = TRUE` alone does not prove the separately fitted old/new models used
  EM after all recovery attempts.
- Disabling `tryFitwholeOldItems` or `tryFitwholeNewItems` must not be described
  as disabling all raw-form recovery unless runtime behavior is changed in a
  dedicated behavior PR with regression evidence.
- Formula-integrity reviews in
  `docs/fixed-parameter-item-calibration.md` apply to orchestration only.
  Estimation mathematics stay in `mirt`.
- `man/autoFIPC.Rd` remains roxygen-generated from `R/aFIPC.R`. Method
  citations belong in these Markdown ADRs and `docs/papers/README.md` unless
  the roxygen `@references` block is updated in the same change.

## Claim boundary

Choosing `mirt` is an engineering dependency decision. The EM/MHRM method
selection and raw-form recovery sequence are implementation behavior, not a
claim that this package contributes a new estimation algorithm or that one
method is universally more accurate. Linking-scale interpretation remains
bounded by ADR-0001 and AERA/APA/NCME (2014).

## References

Chalmers, R. P. (2012). mirt: A multidimensional item response theory
package for the R environment. *Journal of Statistical Software,
48*(6), 1-29. <https://doi.org/10.18637/jss.v048.i06>

Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood
estimation of item parameters: Application of an EM algorithm.
*Psychometrika, 46*(4), 443-459.
<https://doi.org/10.1007/BF02293801>

Kim, S. (2006). A comparative study of IRT fixed parameter calibration
methods. *Journal of Educational Measurement, 43*(4), 355-381.
<https://doi.org/10.1111/j.1745-3984.2006.00021.x>
