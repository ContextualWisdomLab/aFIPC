# ADR-0001: FIPC as the linking contract

- Status: Accepted
- Date: 2026-08-16
- Deciders: maintainers

## Context

`autoFIPC()` places a new IRT form onto an established old-form scale by
declaring common items and calibrating the new form while those anchors
keep their old-form parameter values. The scientific question is which
published linking family that workflow implements.

Kim (2006) frames fixed item parameter calibration (FIPC): old
operational or anchor parameters are treated as known during new-form
calibration so the new form is estimated directly on the base scale.
Kolen and Brennan (2014) survey the broader equating and linking
toolkit, including separate calibration plus a characteristic-curve
transformation, concurrent calibration, and fixed-parameter approaches.
The *Standards for Educational and Psychological Testing*
(AERA, APA, & NCME, 2014) limit how linked scores may be interpreted.

A withdrawn repository cite attributed "Linking item parameters to a
base scale" to Kim and Kolen (2010) in the *Journal of Educational
Measurement*. That record is not a real JEM article. The title belongs
to Kang and Petersen (2012). A real Kim and Kolen FIPC paper is their
2019 *Applied Measurement in Education* application to multiple-group
data.

## Decision

This package implements FIPC as specified by Kim (2006) and restated in
`docs/fixed-parameter-item-calibration.md`:

1. For each eligible anchor pair, copy the old-form item parameter
   vector onto the matching new-form item.
2. Hold those copied parameters fixed (`est := FALSE`) during the
   linked calibration.
3. Estimate only non-anchor new-form parameters on the scale defined by
   the fixed anchors.

`autoFIPC()` orchestrates that contract. It does not estimate a
Stocking–Lord or Haebara transformation. Inspection of `R/aFIPC.R`
shows no characteristic-curve linking objective; the linked call is
`mirt::mirt(..., pars = NewScaleParms)` after the copy-and-fix step.

## Alternatives considered

- **Separate calibration + Stocking and Lord (1983).** Calibrate each
  form freely, then find a linear transformation that matches test
  characteristic curves. Canonical characteristic-curve equating; not
  what `autoFIPC()` computes.
- **Separate calibration + Haebara (1980).** Calibrate each form
  freely, then match item characteristic curves by weighted least
  squares. Also a post-calibration transformation; not implemented
  here.
- **Concurrent calibration.** Estimate both forms in one run with
  shared parameters for common items. `autoFIPC()` instead calibrates
  forms separately and then fixes anchors (Kim, 2006).
- **Kang and Petersen (2012).** Correct source for the title "Linking
  item parameters to a base scale." Useful background on placing
  parameters onto a base scale; not the FIPC contract this package
  implements.
- **Kim and Kolen (2019).** Later FIPC application to multiple-group
  test data. Supports FIPC as a published method family; does not
  replace Kim (2006) as the contract implemented here.

## Consequences

- Maintainers must preserve the copy-and-fix invariant unless a
  regression fixture and explicit maintainer intent say otherwise.
- Docs must contrast FIPC with Stocking–Lord and Haebara so readers do
  not infer that `autoFIPC()` returns those transformation constants.
- Score-scale claims stay inside AERA/APA/NCME (2014) limits: linking
  does not by itself justify interchangeable high-stakes
  interpretations.

## Claim boundary

This package orchestrates FIPC. Estimation of item-response
probabilities, the MML-EM cycles, and scores lives in `mirt` (see
ADR-0002). Accepting FIPC here is not a claim that Stocking–Lord,
Haebara, or concurrent calibration are inferior; they are different
published designs. It is also not a claim that linked scores meet a
particular testing-program validity argument.

## References

Kim, S. (2006). A comparative study of IRT fixed parameter calibration
methods. *Journal of Educational Measurement, 43*(4), 355–381.
<https://doi.org/10.1111/j.1745-3984.2006.00021.x>

Stocking, M. L., & Lord, F. M. (1983). Developing a common metric in
item response theory. *Applied Psychological Measurement, 7*(2),
201–210. <https://doi.org/10.1177/014662168300700208>

Haebara, T. (1980). Equating logistic ability scales by a weighted
least squares method. *Japanese Psychological Research, 22*(3),
144–149. <https://doi.org/10.4992/psycholres1954.22.144>

Kolen, M. J., & Brennan, R. L. (2014). *Test equating, scaling, and
linking: Methods and practices* (3rd ed.). Springer.
<https://doi.org/10.1007/978-1-4939-0317-7>

Kim, S., & Kolen, M. J. (2019). Application of IRT fixed parameter
calibration to multiple-group test data. *Applied Measurement in
Education, 32*(4), 310–324.
<https://doi.org/10.1080/08957347.2019.1660344>

Kang, T., & Petersen, N. S. (2012). Linking item parameters to a base
scale. *Asia Pacific Education Review, 13*(2), 311–321.
<https://doi.org/10.1007/s12564-011-9197-2>

American Educational Research Association, American Psychological
Association, & National Council on Measurement in Education. (2014).
*Standards for educational and psychological testing*. American
Educational Research Association.
