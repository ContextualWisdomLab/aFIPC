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
2. Fit separate old-form and new-form `mirt` models.
3. Run `autoFIPC()` with the shared items declared as common items.
4. Assert that linked common-item `a1` and `d` values equal the old-form values
   and are not estimated in the linked model.
5. Assert that the old-form estimates recover the generating common-item
   parameters closely enough for a small deterministic regression test.

## References

- Kim, S. (2006). A comparative study of IRT fixed parameter calibration
  methods. Journal of Educational Measurement, 43(4), 355-381.
- Chalmers, R. P. `mirt::fixedCalib` documentation. The implementation note
  describes fixed-item calibration methods based on Kim (2006) and points to
  `multipleGroup` for more flexible anchor-item calibration.
- Kim, S., & Kolen, M. J. (2010). Linking item parameters to a base scale.
  Journal of Educational Measurement, 47(2), 164-181.
