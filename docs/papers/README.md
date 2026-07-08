# Source papers for the calibration and linking mathematics

`autoFIPC()` implements the fixed item parameter calibration (FIPC) linking
contract; the underlying IRT estimation is delegated to `mirt`. The canonical
equations this package must match are documented in the sources below.

No PDFs are committed here: the two primary FIPC references (Kim, 2006; Kim &
Kolen, 2010) are published in the *Journal of Educational Measurement* and are
not open access, so they are cited by DOI rather than redistributed, to respect
copyright. The `mirt` reference is open access.

## Primary source — the FIPC linking contract

- **Kim, S. (2006). A comparative study of IRT fixed parameter calibration
  methods.** *Journal of Educational Measurement, 43*(4), 355-381.
  DOI: <https://doi.org/10.1111/j.1745-3984.2006.00021.x>
  - Canonical rule implemented: old-form (anchor) item parameters are treated as
    known and held fixed while the new form is calibrated directly onto the
    established base scale.

- **Kim, S., & Kolen, M. J. (2010). Linking item parameters to a base scale.**
  *Journal of Educational Measurement, 47*(2), 164-181.
  DOI: <https://doi.org/10.1111/j.1745-3984.2010.00107.x>
  - Basis for treating the old-form scale as the fixed base onto which new-form
    parameters are placed.

## Estimation engine (open access)

- **Chalmers, R. P. (2012). mirt: A Multidimensional Item Response Theory
  Package for the R Environment.** *Journal of Statistical Software, 48*(6),
  1-29. DOI: <https://doi.org/10.18637/jss.v048.i06> (open access)
  - Provides the MML-EM estimation, `fscores` (MAP), `expected.test`, and the
    `multipleGroup`/`DIF` machinery used for item parameter drift screening.
  - `?mirt::fixedCalib` documents fixed-item calibration methods based on
    Kim (2006).

## Supporting reference

- **Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood estimation of
  item parameters: Application of an EM algorithm.** *Psychometrika, 46*(4),
  443-459. DOI: <https://doi.org/10.1007/BF02293801>
  - The MML-EM algorithm underlying `mirt`'s `method = "EM"` estimation.

See `../fixed-parameter-item-calibration.md` for the equation restatement, the
formula-integrity audit of the performance refactors, and the tests that pin
these formulas to reference values.
