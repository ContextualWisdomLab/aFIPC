# AGENTS.md

## Mission

Maintain this repository as a stable, reproducible R package for fixed-item
parameter calibration and test linking.

## Non-negotiable guardrails

1. Preserve historical numerical behavior in `R/aFIPC.R` unless there is
   explicit regression evidence and maintainer intent to change behavior.
2. Treat CI/security/docs hygiene as first-class maintenance work.
3. Keep changes minimal and auditable; prefer additive guardrails over broad
   refactoring.

## Required maintenance checks

- Keep `.github/workflows/` green and action SHAs pinned.
- Keep `.github/dependabot.yml` active for GitHub Actions updates.
- Keep `ARCHITECTURE.md` up to date when structure changes.
- Keep README accurate for local verification commands.

## Editing priorities

1. Safety and reproducibility
2. CI reliability
3. Documentation clarity
4. Feature changes

## High-risk areas

- `R/aFIPC.R` contains long legacy logic with interactive prompts.
- Any changes around calibration/linking constraints can alter scientific output.

## Preferred change strategy

- Add tests/fixtures first when behavior changes are required.
- Isolate operational fixes (workflow/docs/dependency policy) from algorithmic
  edits.
- Document assumptions and risk in commit/PR summaries.

---

## Key Literature: Fixed Item Parameter Calibration (FIPC)

This software implements FIPC-based test linking. The following articles are
canonical references for understanding and validating algorithmic choices.

### Foundational / Original Source

- **Kang, T., & Petersen, N. S. (2009).** *Linking item parameters to a base
  scale.* ACT Research Report Series, 2009-2. ERIC: ED510480.
  https://files.eric.ed.gov/fulltext/ED510480.pdf
  > **This is the primary source (원전) for this software.** Compares
  > concurrent calibration, separate calibration with linking, and FIPC using
  > BILOG-MG and PARSCALE. Key finding: **PARSCALE updates the prior ability
  > distribution during FIPC whereas BILOG-MG does not.** Only the PARSCALE
  > implementation (when used correctly) produced results comparable to the
  > other methods.

### Classic / Methodological Foundations

- **Stocking, M. L., & Lord, F. M. (1983).** Developing a common metric in
  item response theory. *Applied Psychological Measurement, 7*(2), 201–210.
  https://doi.org/10.1177/014662168300700208
  > Classic source for scale transformation in IRT linking. Outlines how
  > fixed common-item constraints achieve a common metric across forms.

- **Ban, J.-C., Hanson, B. A., Wang, T., Yi, Q., & Harris, D. J. (2001).**
  A comparative study of on-line pretest item calibration/scaling methods in
  computerized adaptive testing. *Journal of Educational Measurement, 38*(3),
  191–212. https://www.jstor.org/stable/1435120 (also ERIC: ED449201)
  > Compares five online calibration methods for CAT including fixed-parameter
  > approaches. Important for understanding FIPC in adaptive testing contexts.

- **Kolen, M. J., & Brennan, R. L. (2014).** *Test equating, scaling, and
  linking: Methods and practices* (3rd ed.). Springer.
  https://link.springer.com/book/10.1007/978-1-4939-0317-7
  > Definitive textbook. Chapters on IRT linking provide theoretical
  > foundations for FIPC, anchor-item design, and scale maintenance.

- **Kim, S. H., Cohen, A. S., & Kim, H. (2011).** Fixed-parameter calibration
  of item banks. *Applied Psychological Measurement, 35*(7), 559–578.
  https://doi.org/10.1177/0146621611401805
  > Evaluates FIPC effectiveness in large-scale CAT and item banking;
  > confirms accuracy with sufficient well-distributed anchor items.

### Recent Advances (2020–2025)

- **Robitzsch, A. (2024).** Bias and linking error in fixed item parameter
  calibration. *AppliedMath, 4*(3), 1181–1191.
  https://doi.org/10.3390/appliedmath4030063
  > Analytically derives bias and linking error of FIPC under random DIF
  > (2PL model). Shows that as DIF variance grows, both bias and variance of
  > group distribution estimates increase substantially.

- **Robitzsch, A. (2025).** Linking error estimation in fixed item parameter
  calibration: Theory and application in large-scale assessment studies.
  *Foundations, 5*(1), 4. https://doi.org/10.3390/foundations5010004
  > Proposes a bias-corrected linking error estimator. Conventional jackknife
  > resampling estimates are positively biased; this correction is critical for
  > valid statistical inference in large-scale assessments (e.g., PISA).

---

## Software Development Notes (FIPC-Specific)

The following algorithmic and design constraints flow directly from the
literature above and must be respected in all code changes:

1. **Prior ability distribution update during FIPC.**
   Kang & Petersen (2009) found that the key behavioral difference between
   BILOG-MG and PARSCALE was whether the prior ability distribution is updated
   during FIPC. `mirt`-based calibration in this package must be audited for
   which behavior it implements before changing estimation calls.

2. **Anchor/common item quality is critical.**
   At least 20–30 well-distributed anchor items spanning the θ continuum are
   recommended (Kim et al., 2011). The `checkIPD` step in `autoFIPC()` exists
   to detect and flag drifted anchor items before linking; do not disable or
   weaken this check without regression evidence.

3. **Item Parameter Drift (IPD) must be detected before FIPC.**
   IPD (change in item parameters over time or across cohorts) biases FIPC
   linking when drifted items remain in the anchor set. Detection methods
   include robust-Z, D2/WRMSD, RMSD, and likelihood-ratio tests. Items with
   significant drift should be excluded from the anchor set.

4. **DIF and linking error.**
   Unmodeled DIF in anchor items inflates both bias and linking error
   (Robitzsch, 2024). Any future reporting of linking uncertainty must
   account for bias-corrected linking error, not just sampling error.

5. **Comparison reference package.**
   The R package `irtQ` (CRAN) independently implements FIPC for
   dichotomous (1PL/2PL/3PL) and polytomous (GRM/GPCM) models and can be
   used to cross-validate numerical results from `aFIPC`.

6. **Interactive prompts limit automation.**
   The `confirmCommonItems` parameter was added to bypass the interactive
   common-item confirmation step. Any further removal of interactive prompts
   must preserve identical numerical behavior and be covered by regression
   fixtures before merging.
