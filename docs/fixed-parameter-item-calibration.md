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

Regression guards for the two formula-bearing expressions (#56 and #99) are
pinned to hand-computed reference values in
`tests/testthat/test-optimization-equivalence.R`. The end-to-end linking
contract (anchors fixed to old-form values, non-anchors left free) is pinned in
`tests/testthat/test-fixed-parameter-calibration.R`.

## References

- Kim, S. (2006). A comparative study of IRT fixed parameter calibration
  methods. Journal of Educational Measurement, 43(4), 355-381.
- Chalmers, R. P. `mirt::fixedCalib` documentation. The implementation note
  describes fixed-item calibration methods based on Kim (2006) and points to
  `multipleGroup` for more flexible anchor-item calibration.
- Kim, S., & Kolen, M. J. (2010). Linking item parameters to a base scale.
  Journal of Educational Measurement, 47(2), 164-181.
