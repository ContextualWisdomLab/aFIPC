# Fixed Parameter Item Calibration Basis

`autoFIPC()` is maintained as a fixed item parameter calibration workflow. The
core invariant is that common-item parameters from the old form define the base
scale. During new-form calibration, the matching common items in the linked form
must keep those old-form values fixed, and only non-common new-form parameters
should move onto that base scale.

This follows the fixed parameter calibration framing in Kim (2006): old
operational or anchor item parameters are treated as known values during the
new-form calibration so the new form is calibrated directly on the established
scale. The package test `test-fixed-parameter-calibration.R` reproduces this
contract with generated 2PL data:

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

A fitted model and the response data used for linking must also agree on item
identity. The current `mirt::fixedCalib()` documentation explicitly requires
observed responses or `NA` placeholders for item names used by the fitted model.
Accordingly, `autoFIPC()` treats a fitted-model item that is absent from its
response data as a schema error. Performance work may avoid constructing an
intermediate data-frame subset, but it must not turn that error into silent
intersection or item dropping.

## Formula-integrity audit of performance refactors

The estimation mathematics (item-response probabilities, the MML-EM cycles,
`fscores`, `expected.test`, and the DIF/IPD statistics) live in `mirt`; this
package only orchestrates the linking contract above. The following merged
performance refactors were reviewed against that contract and confirmed
**mathematically equivalent** (no term, margin, or constant changed):

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
- **#273**: replace `colnames(df[model_columns])` only after preserving its
  fail-closed schema validation. `.validated_model_columns()` avoids the
  intermediate subset, keeps fitted-model column order, and rejects missing
  response-data columns. `tests/testthat/test-optimization-equivalence.R`
  covers both the ordered success case and the missing-column error.

Regression guards for the formula-bearing expressions are pinned to independent
reference values in `tests/testthat/test-optimization-equivalence.R`. The
end-to-end linking contract (anchors fixed to old-form values, non-anchors left
free) is pinned in `tests/testthat/test-fixed-parameter-calibration.R`.

## Scientific acceptance gap

The package does not yet have product-level Monte Carlo acceptance across
realistic latent-distribution shifts, anchor proportions, sample sizes and item
parameter regimes. Kim (2006) found that FPC performance depends on the prior
ability updating and EM-cycle strategy and on differences between reference and
new-form ability distributions. More recently, Kim, Kim, and Lee (2026) showed
that latent-density misspecification can materially affect IRT equating accuracy;
their study concerns IRT equating rather than this implementation directly, so
it is evidence for a stress-test requirement, not evidence that `autoFIPC()` is
currently biased.

Before claiming scientific release readiness, acceptance should therefore
report true-parameter recovery, RMSE, bias and interval coverage over explicitly
recorded seeds and conditions, including non-normal or shifted latent
distributions and realistic common-item designs. Small deterministic synthetic
tests remain unit/regression evidence, not a substitute for that validation.

## References

- Chalmers, R. P. (2012). mirt: A multidimensional item response theory package
  for the R environment. *Journal of Statistical Software, 48*(6), 1–29.
  https://doi.org/10.18637/jss.v048.i06
- Chalmers, R. P. (n.d.). *Fixed-item calibration method (`mirt::fixedCalib`)*.
  mirt documentation. https://philchalmers.github.io/mirt/docs/reference/fixedCalib.html
- Kang, T., & Petersen, N. S. (2012). Linking item parameters to a base scale.
  *Asia Pacific Education Review, 13*(2), 311–321.
  https://doi.org/10.1007/s12564-011-9197-2
- Kim, K. Y., Kim, S., & Lee, H. (2026). The impact of latent density
  misspecification on item response theory equating methods. *Applied
  Psychological Measurement, 50*(7), 359–375.
  https://doi.org/10.1177/01466216261425440
- Kim, S. (2006). A comparative study of IRT fixed parameter calibration
  methods. *Journal of Educational Measurement, 43*(4), 355–381.
  https://doi.org/10.1111/j.1745-3984.2006.00021.x
