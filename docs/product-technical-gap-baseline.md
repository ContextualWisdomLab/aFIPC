# aFIPC Product–Technical Gap Baseline

Last reviewed against PR #273 after repair commits `3f02b35`, `76ae714`, `a94531d`, and `438e692`. The protected base for this repair started at `master@f87c2324f1686135e57d8730c1b0b9420874f300`. GitHub live state remains authoritative when these identifiers become historical.

## Product boundary

aFIPC owns the R-package workflow for fixed-item parameter calibration/linking around `mirt`. Its domain truth is the mapping of declared common items from an old/base form to a new form, the invariant that eligible anchor parameters remain fixed on the base scale during linked calibration, and the package-level validation/evidence needed to make that behavior reproducible. It does not own `mirt` estimation mathematics or the broader psychometric numerical-kernel roadmap.

The current package metadata is version `0.1.0`. There is no GitHub Release and no `CHANGELOG.md` on the current branch, so an immutable commercial release has not yet been demonstrated.

## Current repaired invariant

PR #273 attempted to replace `colnames(df[model_columns])` with `intersect(model_columns, colnames(df))` to avoid creating an intermediate data-frame subset. That optimization changed behavior: the legacy expression fails when the fitted model expects a column that the response data does not contain, while `intersect()` silently removes it.

That mismatch is not a cosmetic error. A fitted-model/response-data schema disagreement can alter which items reach IPD screening and fixed-parameter linking. The repaired path now uses `.validated_model_columns()` to retain fitted-model order, avoid the intermediate subset, and fail closed with `undefined columns selected` when any required item is absent. The RED/GREEN regression lives in `tests/testthat/test-optimization-equivalence.R`.

Acceptance for this repair is:

- ordered requested item names are returned unchanged when every item exists;
- any fitted-model item missing from response data fails before IPD/linking can silently drop it;
- the end-to-end fixed-anchor contract in `test-fixed-parameter-calibration.R` remains unchanged;
- R CMD check, security and quality checks complete against the same exact PR head before merge;
- no performance percentage or asymptotic improvement is claimed without a reproducible benchmark that compares semantically equivalent implementations.

## Buyer-visible gaps

### Scientific validation

Unit and deterministic regression tests exist, but commercial scientific acceptance is not yet established across realistic ability-distribution shifts, anchor proportions, sample sizes and item-parameter regimes. The next evidence-bearing work should record true generating parameters and deterministic seeds, then report recovery RMSE, bias and interval coverage without excluding failed replications from the denominator. Non-normal and shifted latent distributions must be represented rather than assuming that a nominally normal reference condition is sufficient.

The research trace for this requirement is maintained in `docs/fixed-parameter-item-calibration.md`. Kim (2006) showed that fixed-parameter calibration performance depends on the prior-ability update/EM strategy and population distribution; Kim, Kim, and Lee (2026) provide newer evidence that latent-density misspecification can materially affect IRT equating. The latter is a stress-test rationale, not a claim that aFIPC has already been shown biased.

### Release evidence

A commercial release path needs version/CHANGELOG discipline, reproducible package build/check evidence, an immutable tag/GitHub Release, dependency/SBOM evidence where applicable, provenance, and a documented rollback path. The repository currently has no GitHub Release and no `CHANGELOG.md`, so this gap remains open even if PR #273 becomes code-green.

### Performance evidence

The codebase contains historical comments and `.jules/bolt.md` entries that use complexity/performance language more strongly than the available benchmark evidence supports. PR #273 narrows its own claim to allocation avoidance plus semantic equivalence. Future performance work must profile a buyer-relevant linking workload, preserve numerical/linking contracts, and report workload size, environment, repetitions and uncertainty rather than infer user-visible speedup from an idiom change alone.

## Decision record for PR #273

**Problem.** The proposed allocation optimization converted a schema mismatch from fail-closed to silent item removal.

**Constraint.** `AGENTS.md` requires preservation of historical numerical behavior in `R/aFIPC.R` absent explicit regression evidence and maintainer intent. Fixed-item calibration also depends on stable item identity across fitted model and response data.

**Alternatives considered.** Revert to data-frame subsetting; keep `intersect()` and accept silent dropping; or validate membership without materializing the subset. Silent dropping was rejected because it changes the linking input set. Full reversion was safe but discarded the only plausible optimization. Membership validation with `match()` was selected because it retains order and legacy failure semantics without allocating the intermediate subset.

**Risk.** The helper intentionally preserves the legacy error text rather than introducing a new public error class. If a typed condition becomes part of the package API later, that should be a separate behavior change with its own RED/GREEN tests.

**Effect.** The optimization can proceed without hiding fitted-model/response-data drift. The PR remains non-release-ready until exact-head CI and the broader scientific/release gaps above are resolved.

## References

See `docs/fixed-parameter-item-calibration.md` for the APA 7th research trace, including Kim (2006), Kang and Petersen (2012), Chalmers' `mirt` documentation, and Kim, Kim, and Lee (2026).
