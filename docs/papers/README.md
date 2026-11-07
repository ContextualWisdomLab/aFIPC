# Source papers for the calibration and linking mathematics

`autoFIPC()` implements the fixed item parameter calibration (FIPC)
linking contract; the underlying IRT estimation is delegated to `mirt`.
The canonical sources this package must match are listed below.

No PDFs are committed here. Copyrighted articles are cited by DOI
rather than redistributed. The `mirt` reference is open access.

A previous draft listed Kim and Kolen (2010), "Linking item parameters
to a base scale," *Journal of Educational Measurement, 47*(2),
164–181. That bibliographic record is not a real JEM article and is
not kept. The title belongs to Kang and Petersen (2012). A real Kim
and Kolen FIPC paper is Kim and Kolen (2019).

## Primary source — the FIPC linking contract

- **Kim, S. (2006). A comparative study of IRT fixed parameter
  calibration methods.** *Journal of Educational Measurement, 43*(4),
  355–381.
  DOI: <https://doi.org/10.1111/j.1745-3984.2006.00021.x>
  - Canonical rule implemented: old-form (anchor) item parameters are
    treated as known and held fixed while the new form is calibrated
    directly onto the established base scale.

- **Kim, S., & Kolen, M. J. (2019). Application of IRT fixed parameter
  calibration to multiple-group test data.** *Applied Measurement in
  Education, 32*(4), 310–324.
  DOI: <https://doi.org/10.1080/08957347.2019.1660344>
  - Later FIPC application to multiple-group data. Supports FIPC as a
    published method family; does not replace Kim (2006) as the
    contract `autoFIPC()` implements.

## Characteristic-curve equating (not implemented here)

`autoFIPC()` implements FIPC, not a Stocking–Lord or Haebara
transformation estimator. These papers are the canonical
characteristic-curve methods that FIPC is an alternative to (separate
calibration plus a linking transformation, versus concurrent
calibration, versus FIPC).

- **Stocking, M. L., & Lord, F. M. (1983). Developing a common metric
  in item response theory.** *Applied Psychological Measurement,
  7*(2), 201–210.
  DOI: <https://doi.org/10.1177/014662168300700208>
  - Test characteristic-curve linking after separate calibration.

- **Haebara, T. (1980). Equating logistic ability scales by a weighted
  least squares method.** *Japanese Psychological Research, 22*(3),
  144–149.
  DOI: <https://doi.org/10.4992/psycholres1954.22.144>
  - Item characteristic-curve linking by weighted least squares after
    separate calibration.

## Equating and linking handbook

- **Kolen, M. J., & Brennan, R. L. (2014). *Test equating, scaling,
  and linking: Methods and practices* (3rd ed.).** Springer.
  DOI: <https://doi.org/10.1007/978-1-4939-0317-7>
  - Handbook survey of equating, scaling, and linking designs,
    including the families contrasted above.

## Correct source for the withdrawn title

- **Kang, T., & Petersen, N. S. (2012). Linking item parameters to a
  base scale.** *Asia Pacific Education Review, 13*(2), 311–321.
  DOI: <https://doi.org/10.1007/s12564-011-9197-2>
  - Real paper with this title (also circulated as ACT Research Report
    2009-2). Not the FIPC contract implemented here.

## Estimation engine (open access)

- **Chalmers, R. P. (2012). mirt: A multidimensional item response
  theory package for the R environment.** *Journal of Statistical
  Software, 48*(6), 1–29.
  DOI: <https://doi.org/10.18637/jss.v048.i06> (open access)
  - Provides the MML-EM estimation, `fscores` (MAP), `expected.test`,
    and the `multipleGroup`/`DIF` machinery used for item parameter
    drift screening.
  - `?mirt::fixedCalib` documents fixed-item calibration methods based
    on Kim (2006).

- **Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood
  estimation of item parameters: Application of an EM algorithm.**
  *Psychometrika, 46*(4), 443–459.
  DOI: <https://doi.org/10.1007/BF02293801>
  - The MML-EM algorithm underlying `mirt`'s `method = "EM"`
    estimation.

## Score-scale interpretation limits

- **American Educational Research Association, American Psychological
  Association, & National Council on Measurement in Education.
  (2014). *Standards for educational and psychological testing*.**
  American Educational Research Association.
  - Limits on how linked scores and scales may be interpreted. No DOI
    is used here; none was verified for this edition.

See `../fixed-parameter-item-calibration.md` for the equation
restatement, the formula-integrity audit of the performance refactors,
and the tests that pin these formulas to reference values. Method
decisions are recorded in `../adr/`.
