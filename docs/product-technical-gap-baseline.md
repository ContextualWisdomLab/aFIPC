# Product / Technical Gap Baseline

This document records code-current commercial and technical gaps for aFIPC. It is not a roadmap promise and does not turn an open proposal into an accepted architecture decision.

## Product boundary

aFIPC owns fixed-item-parameter calibration/linking behavior and the domain meaning of its form, common-item, calibration, prior, linking, and recovery contracts. Shared psychometric kernels may be consumed through released/versioned boundaries when they preserve that product contract; aFIPC does not copy a sibling repository's source or depend on a mutable sibling head.

Protected repository authority at this baseline is `master@f87c2324f1686135e57d8730c1b0b9420874f300`. Open PRs are evidence/proposals until they satisfy the live protected-branch gates and merge normally.

## Commercial blocker: runtime and repository licensing

Issue #320 is the current commercial-intake blocker. The package metadata declares GPL-3 and the core calibration path imports/calls `mirt`, whose CRAN license is GPL (>= 3). Those are separate obligations: changing repository prose or a root license file cannot make the current runtime dependency graph compatible with ContextualWisdomLab's no-GPL-family intake baseline.

Acceptance for a commercially cleared successor is therefore behavioral and provenance-based, not merely textual:

- establish first-party/contributor provenance before changing the repository grant;
- remove or replace GPL/LGPL/AGPL-family runtime, build, vendored, copied-source, or derivative obligations under the intended distribution model;
- preserve the actual fixed-item calibration/linking estimand rather than substituting a different psychometric method to obtain a different license;
- keep package metadata, root license bytes, dependency inventory, SBOM and release evidence mutually consistent;
- retain normal R compatibility only as an explicit boundary while any Rust-first replacement kernel is validated.

A released `fast-mlsirm` capability may be evaluated as an optional canonical kernel boundary when it actually provides the required estimand and numerical contract. Until then it is a read-only dependency candidate, not a source-copy or mutable-head shortcut.

## Numerical and psychometric evidence gap

A replacement calibration runtime is not GREEN merely because unit tests execute. Acceptance must preserve observable aFIPC outputs over right-cleared representative product data and, where simulation is scientifically appropriate, report true-parameter recovery rather than synthetic-data success alone.

Required evidence for the replacement/calibration boundary:

- fixed common-item identities and ordering;
- linked item-parameter selection and scale behavior;
- convergence/recovery-path attribution across the currently supported estimation/recovery paths;
- reproducibility under pinned runtime/package/kernel versions;
- simulation studies that report true-parameter bias, RMSE and interval coverage with the data-generating design stated explicitly;
- real/right-cleared product-form replay for commercial acceptance, with synthetic data confined to unit/property/recovery tests.

Any material numerical difference requires an explicit ADR with the estimand, constraint, alternatives, reason for acceptance/rejection, measured effect, migration risk and rollback path.

## Current correctness lane: interactive choice domain

The three interactive yes/no menu boundaries document `1` or `2`. PR #337 is the current repaired candidate that narrows admission before integer coercion and carries deterministic production-path regressions. It remains Draft until one unchanged exact head has terminal R CMD/test, applicable security/SAST/CodeQL evidence, current review findings resolved, protected-base compatibility, and qualifying independent review.

The supported finding is input-contract/reliability correctness. Oversized decimal coercion to `NA` is not, without additional evidence, proof of integer overflow, memory corruption, remote exploitation, or a specific security severity.

## Current performance lanes

Several open branches propose R-level micro-optimizations in the calibration/linking path. Their admissible evidence is narrower than their generated performance language:

- direct model-column lookup must preserve the source/model column-membership validation that the protected data-frame projection currently provides;
- distinct non-missing category refactors must preserve observed-category semantics, including NA/NaN/factor edge cases;
- local expression or allocation changes are not buyer-visible performance improvements until the actual `autoFIPC()` path is measured.

Performance promotion requires representative item/respondent/form cardinalities, pinned R/runtime/dependency state, warm-up policy, repeated wall-time distribution including median and p95, allocation/GC or equivalent profile evidence, and numerical-equivalence checks. A unit test, coverage result, or isolated operation-count benchmark is correctness evidence only.

If profiling shows a material psychometric hot path rather than incidental R overhead, prefer an auditable Rust-first kernel boundary with vector/linear/matrix operations and CPU multithreading, while preserving the product-owned R/API/domain contract through an adapter. Do not migrate a hot path on style grounds alone.

## Release and rollback gap

No open branch is a release by itself. A release-ready protected generation must have:

- one exact protected head after normal reviewed merge;
- terminal required repository and organization checks on that generation;
- numerical/behavioral evidence appropriate to the changed domain boundary;
- version and CHANGELOG aligned with the shipped behavior;
- immutable tag/package plus SBOM and provenance;
- reproducibility instructions and a tested rollback/recovery path.

Until the licensing blocker and the applicable correctness/numerical gates are resolved, documentation must not describe aFIPC as commercially intake-cleared or a replacement runtime as behaviorally equivalent.

## Traceability

- Commercial/runtime licensing owner: issue #320.
- Product/method documentation owner lane: PR #261.
- Interactive choice-domain repair candidate: PR #337.
- Model-column performance/validation candidate: PR #335.
- Protected repository authority recorded above remains the merge/release source of truth.
- CRAN `mirt` package metadata is the primary external license reference; Chalmers (2012), *Journal of Statistical Software, 48*(6), documents the `mirt` estimation framework. External references support the decision record but do not supersede live repository code, dependency bytes, or protected-branch rules.
