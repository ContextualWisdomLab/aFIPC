<!-- markdownlint-configure-file { "MD013": { "line_length": 120 } } -->

# Psychometric references

This file records, in APA 7th-edition form, the psychometric literature that
grounds the regression and robustness tests under `tests/testthat/`. Each work
was verified against its publisher record (journal, volume, issue, pages, and
DOI) rather than reproduced from memory.

> Note: a local Zotero API is not reachable from the build/CI sandbox, so this
> in-repo, version-controlled reference list is the achievable substitute for a
> Zotero-managed bibliography. Keep it in sync with the citation headers in the
> test files.

## Cited works

- Bock, R. D., & Aitkin, M. (1981). Marginal maximum likelihood estimation
  of item parameters: Application of an EM algorithm. *Psychometrika, 46*(4),
  443–459. <https://doi.org/10.1007/BF02293801>
- Cai, L. (2010). High-dimensional exploratory item factor analysis by a
  Metropolis–Hastings Robbins–Monro algorithm. *Psychometrika, 75*(1), 33–57.
  <https://doi.org/10.1007/s11336-009-9136-x>
- Chalmers, R. P. (2012). mirt: A multidimensional item response theory
  package for the R environment. *Journal of Statistical Software, 48*(6),
  1–29. <https://doi.org/10.18637/jss.v048.i06>
- Kim, S. (2006). A comparative study of IRT fixed parameter calibration
  methods. *Journal of Educational Measurement, 43*(4), 355–381.
  <https://doi.org/10.1111/j.1745-3984.2006.00021.x>
- Kim, S., & Kolen, M. J. (2010). Linking item parameters to a base scale.
  *Journal of Educational Measurement, 47*(2), 164–181.
  <https://doi.org/10.1111/j.1745-3984.2010.00106.x>
- Mislevy, R. J., & Wu, P.-K. (1996). *Missing responses and IRT ability
  estimation: Omits, choice, time limits, and adaptive testing* (ETS Research
  Report No. RR-96-30-ONR). Educational Testing Service.
  <https://doi.org/10.1002/j.2333-8504.1996.tb01708.x>

## How each test file is grounded

- `test-kim2006-fixed-anchor-invariant.R` — Fixed-item-parameter linking
  invariant: anchors keep their old-form values and stay fixed while
  non-anchors are estimated onto the base scale (Kim, 2006; Bock & Aitkin,
  1981; Chalmers, 2012).
- `test-se-hessian-vcov-preservation.R` — `SE = TRUE` observed-information /
  covariance matrix and the second-order optimality test are preserved through
  linking on the old, new, and linked models (Bock & Aitkin, 1981; Cai, 2010;
  Chalmers, 2012).
- `test-concurrent-missing-robustness.R` — Planned-missing / non-overlapping
  booklet designs calibrate without error under ignorable missingness, and
  anchors stay fixed (Bock & Aitkin, 1981; Mislevy & Wu, 1996; Kim, 2006).
- `test-degenerate-response-robustness.R` — Zero-score, perfect-score, and
  skewed (near-degenerate) response patterns produce finite item parameters,
  MAP abilities, and expected scores rather than crashing (Bock & Aitkin,
  1981; Mislevy & Wu, 1996; Kim, 2006).
- `test-fixed-parameter-calibration.R` (pre-existing) — End-to-end linking
  contract fixture (Kim, 2006).
