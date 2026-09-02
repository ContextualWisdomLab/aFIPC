# Fixed Parameter Item Calibration Basis

`autoFIPC()` is maintained as a fixed item parameter calibration workflow. The
core invariant is that common-item parameters from the old form define the base
scale. During new-form calibration, the matching common items in the linked form
must keep those old-form values fixed, and only non-common new-form parameters
should move onto that base scale.

This follows the fixed parameter calibration framing in Kim (2006): old
operational or anchor item parameters are treated as known values during the
new-form calibration so the new form is calibrated directly on the established
scale. FIPC is one published linking design among others. Separate calibration
plus a Stocking and Lord (1983) or Haebara (1980) characteristic-curve
transformation, and concurrent calibration of both forms, are alternatives
surveyed by Kolen and Brennan (2014). `autoFIPC()` implements FIPC only: it
copies old-form anchor values, holds them fixed, and re-estimates free new-form
parameters in `mirt`. It does not estimate a Stocking-Lord or Haebara linking
transformation.

The package test `test-fixed-parameter-calibration.R` reproduces this contract
with generated 2PL data:

1. Generate old-form and new-form responses from known true item parameters.
   The generated forms include all-zero and all-one response rows plus missing
   responses on a common item.
2. Fit separate old-form and new-form `mirt` models.
3. Run `autoFIPC()` with the shared items declared as common items.
4. Assert that linked common-item `a1` and `d` values equal the old-form values
   and are not estimated in the linked model.
5. Assert that the old-form estimates recover the generating common-item
   parameters closely enough for a small deterministic regression test.
6. Fit with `SE = TRUE` and assert finite Hessian-derived covariance matrices
   plus passing `secondordertest` results for the old, new, and linked models.

## Canonical linking contract

For each declared anchor pair `(x_j, y_j)` where `x_j` is a new-form item and
`y_j` its old-form counterpart, fixed item parameter calibration sets the
new-form item parameter vector to the old-form estimate and holds it fixed
during the linked calibration:

```text
item_parms(x_j) := item_parms(y_j)    and      est(x_j) := FALSE
```

while every non-anchor new-form parameter stays free and is estimated on the
base scale defined by the fixed anchors (Kim, 2006). An anchor pair is only
eligible when both items share the same number of scored response categories,
i.e. `n_cat(x_j) == n_cat(y_j)` where `n_cat` counts distinct non-missing
responses.

## Estimation-path boundary

`mirt` owns the numerical estimation algorithms. aFIPC chooses among those
algorithms at distinct stages rather than applying one method label to every
returned model:

- If old/new inputs are raw response data, `autoFIPC()` first builds separate
  form models. When an initial fit is unacceptable and whole-form retry is
  enabled, source can retry QMCEM, then MHRM, followed by `surveyFA()` recovery
  variants. Those recovery choices can occur even when `tryEM = TRUE`.
- The linked FIPC model uses `method = "EM"` when the item type is nominal or
  `tryEM = TRUE`; for non-nominal items with `tryEM = FALSE`, it uses MHRM.
- IPD/DIF screening follows the same EM-versus-MHRM selection rule as the
  linked fit.

Therefore, `tryEM = TRUE` is not evidence that the separately returned old/new
form models were ultimately fitted by MML-EM. Reproducibility evidence should
record the actual fitted-model path when method identity matters.

## Formula-integrity audit of performance refactors

The estimation mathematics (item-response probabilities, EM/QMCEM/MHRM
algorithms, `fscores`, `expected.test`, and DIF/IPD statistics) live in `mirt`;
this package only orchestrates the linking and recovery contracts above. The
following merged performance refactors were reviewed against that contract and
confirmed **mathematically equivalent** (no term, margin, or constant changed):

- **#48 / #52** (`82fa77d`, `762b8a9`): hoist `fscores(..., method = 'MAP')`
  into a variable reused by `expected.test` instead of recomputing it. MAP
  scoring is deterministic for a fixed fitted model, so the reused value is
  identical to the second call.
- **#51** (`07e94d2`): replace anchored-regex `grep('^name$', cols)` anchor
  lookups with `match(name, cols)`. For unique column names both return the
  single matching index; `match` is exact-string and avoids regex
  metacharacter hazards. The linked parameter values are unchanged.
- **#56** (`fc8bbfb`): category-count guard rewritten from
  `length(levels(as.factor(x)))` to `length(na.omit(unique(x)))`. Both count
  distinct non-missing response categories; factor levels already exclude `NA`.
- **#99** (`d73adbd`): vectorize IPD anchor extraction from a per-column loop
  to `as.character(unlist(IPDItemList[row, cols]))`. Row 1 (old form), row 2
  (new form), and the screened column order are all preserved exactly.

Regression guards for the two formula-bearing expressions (#56 and #99) are
pinned to hand-computed reference values in
`tests/testthat/test-optimization-equivalence.R`. The end-to-end linking
contract (anchors fixed to old-form values, non-anchors left free) is pinned in
`tests/testthat/test-fixed-parameter-calibration.R`.

## Relation to other linking methods

Kolen and Brennan (2014) organize common IRT linking designs as:

- **Separate calibration + characteristic-curve transformation.** Each form is
  calibrated freely. A linear transformation is then chosen to match test
  characteristic curves (Stocking & Lord, 1983) or item characteristic curves
  (Haebara, 1980).
- **Concurrent calibration.** Both forms are estimated in one run with shared
  parameters for common items.
- **Fixed item parameter calibration (FIPC).** Anchor parameters from the old
  form are treated as known and held fixed while the new form is calibrated
  onto that scale (Kim, 2006; see also Kim & Kolen, 2019, for a later
  multiple-group FIPC application).

`R/aFIPC.R` implements the third design. There is no Stocking-Lord or Haebara
objective, and no post-calibration slope/intercept estimator. An earlier draft
incorrectly attributed "Linking item parameters to a base scale" to Kim and
Kolen (2010) in the *Journal of Educational Measurement*; that attribution was
removed. The title belongs to Kang and Petersen (2012).

Linked scores still fall under the interpretation limits in the *Standards for
Educational and Psychological Testing* (AERA, APA, & NCME, 2014). The linked
fit defaults to `mirt` MML-EM because `tryEM` defaults to true, while the
explicit non-EM and raw-form recovery paths above remain valid implementation
behavior. See `docs/adr/` for the accepted method decisions.

## mirt documentation/version evidence

`DESCRIPTION` imports `mirt` without pinning an exact package version, so this
document must not imply one historical version is permanently authoritative.
At the 2026-09-02 documentation review, the current CRAN package was `mirt`
1.47. Reproducibility evidence should record the installed version actually
used for a calibration run.

- CRAN package record: <https://cran.r-project.org/package=mirt>
- CRAN reference manual: <https://cran.r-project.org/web/packages/mirt/mirt.pdf>

The upstream `fixedCalib` documentation describes fixed-item calibration based
on Kim (2006) and points to `multipleGroup` for more flexible anchor-item
calibration. The Chalmers (2012) package citation below is the scientific
package reference; the CRAN record/manual are the executable documentation
locators.

## References

Kim, S. (2006). A comparative study of IRT fixed parameter calibration
methods. *Journal of Educational Measurement, 43*(4), 355-381.
<https://doi.org/10.1111/j.1745-3984.2006.00021.x>

Stocking, M. L., & Lord, F. M. (1983). Developing a common metric in
item response theory. *Applied Psychological Measurement, 7*(2),
201-210. <https://doi.org/10.1177/014662168300700208>

Haebara, T. (1980). Equating logistic ability scales by a weighted
least squares method. *Japanese Psychological Research, 22*(3),
144-149. <https://doi.org/10.4992/psycholres1954.22.144>

Kolen, M. J., & Brennan, R. L. (2014). *Test equating, scaling, and
linking: Methods and practices* (3rd ed.). Springer.
<https://doi.org/10.1007/978-1-4939-0317-7>

Kim, S., & Kolen, M. J. (2019). Application of IRT fixed parameter
calibration to multiple-group test data. *Applied Measurement in
Education, 32*(4), 310-324.
<https://doi.org/10.1080/08957347.2019.1660344>

Kang, T., & Petersen, N. S. (2012). Linking item parameters to a base
scale. *Asia Pacific Education Review, 13*(2), 311-321.
<https://doi.org/10.1007/s12564-011-9197-2>

Chalmers, R. P. (2012). mirt: A multidimensional item response theory
package for the R environment. *Journal of Statistical Software,
48*(6), 1-29. <https://doi.org/10.18637/jss.v048.i06>

Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood
estimation of item parameters: Application of an EM algorithm.
*Psychometrika, 46*(4), 443-459.
<https://doi.org/10.1007/BF02293801>

American Educational Research Association, American Psychological
Association, & National Council on Measurement in Education. (2014).
*Standards for educational and psychological testing*. American
Educational Research Association.
