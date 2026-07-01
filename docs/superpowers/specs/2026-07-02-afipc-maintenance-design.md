# aFIPC Maintenance Design

## Purpose

Build a concrete maintenance package for `ContextualWisdomLab/aFIPC` using
Figma, Product Design, Superpowers, Ponytail, and Data Analytics without using
Figma Code Connect.

The package exists to help maintainers decide what to do with the live PR queue
while preserving the historical numerical behavior of `autoFIPC()`.

## Current Evidence

Evidence was refreshed on 2026-07-02 from the local checkout and live GitHub
state.

- Repository: `ContextualWisdomLab/aFIPC`
- Visibility: public
- Default branch: `master`
- Primary runtime shape: R package with a large historical `packrat/` vendor
  tree
- Core algorithm file: `R/aFIPC.R`
- Local checkout branch for this planning work:
  `codex/afipc-maintenance-planning`
- Open PRs: 19
- Open issues: 4
- Active workflows: Code Quality, CodeQL, Dependency Review, R CMD check,
  Scorecard supply-chain security, Security Audit
- `packrat/`: 58 MB and 1,876 tracked files
- Non-`packrat/` tracked files: 43
- Figma/FigJam artifact:
  [FigJam board](https://www.figma.com/board/G6GNn2sGFJ19T8uFv9EtgI)

Earlier planning observed 20 open PRs. The live refresh supersedes that count.

## Non-Negotiable Constraints

- Do not use Figma Code Connect.
- Do not call `get_code_connect_map`, `get_code_connect_suggestions`,
  `get_context_for_code_connect`, or the `figma-code-connect` skill.
- Do not alter `autoFIPC()` numerical behavior without fixture-backed
  regression evidence and maintainer intent.
- Do not build a new frontend app or dashboard for this R package.
- Keep operational, documentation, and algorithmic changes in separate PRs.
- Prefer closing duplicated bot PRs over merging multiple branches that touch
  the same legacy logic.
- Treat `AGENTS.md` as the repository's operating contract.

## Tool Roles

### Data Analytics

Use GitHub and repository evidence to classify the PR/issue queue, identify
duplicate work, and recommend merge or close order. The analysis is based on
live PR state, review state, failed checks, and the package risk model.

### Figma

Use Figma only for editable planning artifacts:

- `generate_diagram` for FigJam diagrams
- `use_figma` for future non-Code-Connect edits to Figma files
- `get_metadata` and `get_screenshot` for future design-file inspection
- `create_new_file` only when a new design or board is needed

The current FigJam diagram is a maintenance decision flow. It shows evidence
refresh, PR classification, regression/security/performance/governance lanes,
validation gates, merge-or-close decisions, and queue cleanup repetition.

### Product Design

Audit the developer and maintainer experience rather than a product UI. The
target surfaces are:

- `README.md`
- `ARCHITECTURE.md`
- `AGENTS.md`
- `CONTRIBUTING.md`
- `docs/operations/maintenance-runbook.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/*.md`

The Product Design outcome is a maintainer journey with fewer ambiguous next
steps: how to triage PRs, when to demand regression evidence, where to document
Figma/FigJam artifacts, and when to close duplicated bot work.

### Ponytail

Apply the smallest solution that works. For this repository that means:

- no new app
- no new dashboard runtime
- no broad refactor of `R/aFIPC.R`
- no custom analytics system
- use GitHub state, Markdown docs, and one FigJam diagram
- reduce work by closing duplicates and avoiding speculative abstractions

### Superpowers

Use a durable design spec and execution plan. The spec captures scope,
constraints, evidence, and risks. The plan decomposes the next execution pass
into reviewable tasks with commands and verification gates.

## PR Queue Classification

### Regression Lane

- PR #87: fixture-backed prior-update and IPD anchor filtering coverage.
- Current state: blocked, review required, failing `quality`, `check`, and
  `opencode-review`.
- Decision: highest strategic value, but not mergeable until failures are
  diagnosed and fixed.
- Reason: this creates the regression evidence needed before touching
  high-risk numerical behavior.

### Sentinel Security Lane

- PRs: #88, #86, #83, #82, #77, #74, #71.
- Theme: non-interactive prompt, infinite loop, retry, and DoS handling around
  `autoFIPC()`.
- Current best candidates: #86 and #83 are approved but behind; #88 has all
  key checks passing but has changes requested.
- Dirty or stale duplicates: #82, #77, #74, #71.
- Decision: compare the cleanest approved/current Sentinel branch against
  `master`, keep one implementation, close or supersede older duplicates.

### Bolt Performance Lane

- PRs: #89, #85, #84, #81, #79, #76, #75, #73, #72.
- Theme: repeated `fscores()` caching, item lookup caching, vectorized common
  item extraction, and string matching changes.
- Current best candidates: #85 and #84 are approved but behind; #89 is newer
  and checks pass but has changes requested.
- Dirty or stale duplicates: #81, #79, #76, #75, #73, #72.
- Decision: merge at most one narrowly measured optimization after regression
  coverage is in place. Close overlapping dirty branches.

### Product/Palette Lane

- PR #70: Palette/test coverage/non-interactive behavior.
- Current state: blocked, changes requested, checks passing.
- Decision: do not treat this as a UI improvement, because the repository has
  no frontend product. Extract any useful test coverage only if it is not
  already covered by the regression lane.

### Governance Lane

- PR #80: OpenSSF readiness baseline.
- Current state: behind, review required, failing `opencode-review`.
- Decision: lower priority than regression and security work. Re-evaluate after
  queue pressure is reduced.

### Dependabot Lane

- No open Dependabot PRs were found in the refreshed queue.
- Recent default-branch commits show Dependabot updates already merged.

## Open Issue Alignment

- Issue #44: 100% `testthat()` coverage. This should not drive broad tests for
  their own sake. Use it to prioritize regression tests around `autoFIPC()`.
- Issue #8: maintainer operations cadence. The runbook and FigJam flow support
  this directly.
- Issue #7: numerical regression safety net. PR #87 is the first lane to fix.
- Issue #6: CI gates and Dependabot queue. Current workflows are active, but
  PR queue pressure remains unresolved.

## Product Design Audit Findings

### Strengths

- `AGENTS.md` clearly prioritizes numerical stability and small changes.
- `README.md` names the package status and local check command.
- `ARCHITECTURE.md` identifies `R/aFIPC.R` as the high-risk core.
- The PR template asks for behavioral impact and regression evidence.
- Issue templates ask for reproduction and numerical behavior notes.

### Gaps

- The maintenance runbook still uses `seonghobae/aFIPC` in several commands,
  while the active target is `ContextualWisdomLab/aFIPC`.
- The runbook lists weekly commands but does not explain duplicate bot PR
  grouping, superseding, or close criteria.
- There is no durable place to link Figma/FigJam maintenance boards.
- The PR template does not ask contributors to classify changes as
  regression, security, performance, governance, or documentation.
- CodeGraph is not initialized in this checkout, so structural symbol queries
  are unavailable until the user approves `codegraph init -i`.

## Ponytail Simplification Findings

- The largest removable complexity candidate is `packrat/`, but removal is not
  a first step because it affects reproducibility and historical dependency
  expectations.
- The fastest queue reduction is not code modification. It is duplicate PR
  consolidation.
- The single high-risk file, `R/aFIPC.R`, should not be split until regression
  fixture coverage exists and a narrower extraction target is proven.
- Governance docs should be patched only where they reduce maintainer
  ambiguity. Do not add a new process framework.

## Recommended Decision Order

1. Fix or replace PR #87 so prior-update and IPD anchor behavior are covered by
   deterministic regression tests.
2. Select one Sentinel DoS branch, rebase it, verify `R CMD check`, and close
   older overlapping Sentinel PRs as superseded.
3. Select one Bolt optimization branch only after regression coverage passes.
4. Patch the maintenance runbook and PR template for queue classification and
   duplicate-close policy.
5. Revisit OpenSSF/governance PR #80 after the algorithm-adjacent queue is
   smaller.
6. Defer `packrat/` migration to a dedicated proposal with reproducibility
   rollback notes.

## Figma/FigJam Deliverables

Created:

- `aFIPC Maintenance Decision Flow`
- URL: [FigJam board](https://www.figma.com/board/G6GNn2sGFJ19T8uFv9EtgI)
- Method: Figma `generate_diagram`
- Code Connect: not used

Candidate future boards:

- `autoFIPC()` calibration and linking flow
- IPD anchor filtering flow
- CI/security workflow dependency map
- PR queue swimlane board

## Risks

- Merging multiple Sentinel or Bolt PRs can create conflicting edits around the
  same legacy function.
- Passing checks alone does not prove numerical preservation.
- `packrat/` removal could make historical rebuilds harder.
- A documentation-only plan can go stale quickly if PR state changes; live
  GitHub state must be refreshed before execution.

## Acceptance Criteria

- The repo has a durable spec and plan under `docs/superpowers/`.
- The spec explicitly forbids Figma Code Connect.
- The spec includes live PR and issue classification.
- The spec includes Product Design developer-experience findings.
- The spec includes Ponytail simplification findings and non-goals.
- The plan includes exact commands and validation gates.
- A non-Code-Connect FigJam artifact is linked.
- No algorithmic or numerical behavior is changed by this planning work.
