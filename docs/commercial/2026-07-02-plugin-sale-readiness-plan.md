# Plugin-Driven KRW 2B Sale-Readiness Plan

## Purpose

This plan defines what can be done with Figma, Product Design, Superpowers,
Ponytail, and Data Analytics to move `aFIPC` from technically validated software
to a buyer-ready sale package. Figma Code Connect is explicitly out of scope.

Current repository baseline:

- single-command validation: `scripts/validate-sale-readiness.R`;
- local gate result: `SALE_READINESS_OK`;
- technical diligence pack:
  `docs/commercial/2026-07-02-krw-2b-sale-readiness.md`;
- verification evidence:
  `docs/validation/2026-07-02-sale-readiness-evidence.md`.

Figma FigJam planning artifact:

- <https://www.figma.com/board/jD7NBmiuHUC0SRPhkTAGJk?utm_source=codex&utm_content=edit_in_figjam&oai_id=&request_id=cca2c104-985a-4dac-b27a-57853c527805>

Sale-room index:

- `docs/commercial/2026-07-02-sale-room-index.md`

## Phase 3 Execution Status

Current executed items:

- Figma authentication confirmed for the workspace user.
- Existing FigJam planning board updated with the v2 sale-readiness gate.
- Figma Slides buyer deck generated for technical diligence and investment
  committee review.
- GitHub/Data Analytics lookup for PR #92 confirms the current branch head,
  unresolved review-thread count, and current-head check conclusions. If a
  documentation-only evidence refresh starts new queued checks, that queue state
  is documented separately from code/test/security blockers.
- Repository structure decision recorded: keep `aFIPC` as one R package and one
  sale unit for the current transaction package; do not split a library or add a
  submodule before buyer acceptance.

## Plugin Roles

### Figma

Use Figma for buyer-facing artifacts, not Code Connect.

Deliverables:

- FigJam sale-readiness execution flow.
- Figma Slides buyer deck for technical diligence.
- Visual one-page product brief covering value proposition, validation status,
  included/excluded scope, and handover checklist.
- Optional technical architecture board showing `autoFIPC()`, `surveyFA()`,
  regression fixtures, validation script, and CI evidence flow.

Acceptance criteria:

- No Code Connect mapping or generated code metadata is used.
- Every visual artifact points back to repository evidence.
- The buyer can distinguish validated facts from commercial assumptions.

### Product Design

Use Product Design work to package `aFIPC` as a product, not only as code.

Deliverables:

- Buyer personas: assessment publisher, psychometrics team, edtech platform,
  research lab.
- Jobs-to-be-done: fixed item parameter linking, legacy calibration preservation,
  reproducible technical diligence, handover readiness.
- Product promise and non-promise statements.
- Sale-room information architecture.
- Buyer acceptance checklist.

Acceptance criteria:

- Product story is tied to verified behavior, not inflated claims.
- Known limits are stated before negotiation.
- The package has a clear "what the buyer receives" list.

### Superpowers

Use Superpowers as the execution operating model.

Deliverables:

- Task breakdown with owners, status, evidence, and next action.
- Definition of done for sale-readiness.
- Non-blocker policy for review bots and external model delays.
- Autonomous execution loop: inspect, implement, validate, document, commit.

Acceptance criteria:

- Every task has an executable verification command or concrete artifact.
- No task depends on a review bot before local validation passes.
- The plan can be resumed from repository state alone.

### Ponytail

Use Ponytail for positioning, naming, and narrative polish.

Deliverables:

- Sale-package naming: "aFIPC Fixed-Parameter Calibration Package".
- Short positioning statement.
- Buyer-facing claim language with evidence references.
- Risk-safe marketing copy that does not overpromise arbitrary data success.
- Handover email and data-room index draft.

Acceptance criteria:

- No unsupported pricing guarantee is claimed.
- Scientific/psychometric terminology is preserved.
- Marketing language remains compatible with GPL-3 and technical evidence.

### Data Analytics

Use Data Analytics to convert repository and CI state into diligence evidence.

Deliverables:

- GitHub commit and workflow evidence for the sale-readiness branch.
- Validation trend table: test pass count, warnings, R CMD check status, notes.
- Open issue/PR risk register.
- Evidence appendix for buyer Q&A.
- Optional Gmail workflow for sale-room correspondence, if buyer communication is
  handled through Gmail.

Acceptance criteria:

- Evidence is sourced from repository state or GitHub workflow data.
- Metrics separate product quality from process delays.
- CRAN new-submission NOTE is classified as a documented non-blocker.

## Execution Plan

### Phase 1: Evidence Lock

1. Run `R_PROFILE_USER=/dev/null Rscript scripts/validate-sale-readiness.R`.
2. Record `SALE_READINESS_OK` in the validation evidence document.
3. Use GitHub/Data Analytics to collect latest commit and workflow run evidence.
4. Confirm worktree cleanliness and branch name.

Output:

- refreshed validation evidence;
- release candidate commit SHA;
- blocker/non-blocker table.

### Phase 2: Product Packaging

1. Convert technical diligence pack into buyer-facing product package.
2. Add product scope, use cases, buyer personas, and handover boundaries.
3. Draft a data-room index:
   - source repository;
   - validation evidence;
   - architecture;
   - runbook;
   - license;
   - known limits;
   - Figma sales assets.

Output:

- productized sale-room package;
- buyer acceptance checklist.

Structure decision:

- Keep the current package/repository as the sale unit for this phase.
- Do not introduce a submodule before buyer acceptance because it increases
  checkout, ownership, and validation friction without improving the current
  evidence gate.
- Defer any library extraction until after buyer acceptance and only after
  numerical-equivalence regression fixtures exist.

### Phase 3: Figma Assets

1. Keep the FigJam execution flow as the operating map.
2. Generate a Figma Slides deck:
   - problem and buyer need;
   - product scope;
   - validated technical evidence;
   - sale-readiness gates;
   - handover model;
   - known limits;
   - close/next steps.
3. Create a one-page visual brief for executives.

Output:

- FigJam flow;
- Figma Slides deck;
- executive product brief.

### Phase 4: Analytics Pack

1. Pull GitHub evidence for the current branch/commit.
2. Summarize recent workflow status and validation commands.
3. Build a short diligence metric table:
   - test assertions passed;
   - test failures;
   - test warnings;
   - package check errors;
   - package check warnings;
   - package check notes;
   - unresolved blockers.

Output:

- analytics appendix for buyer due diligence.

### Phase 5: Final Sale Gate

The program is sale-package-ready only when all are true:

- `scripts/validate-sale-readiness.R` prints `SALE_READINESS_OK`;
- repository has a clean worktree;
- Figma assets exist and reference repository evidence;
- sale-room index exists;
- known limits are listed;
- no undisclosed blocker remains;
- review-bot delay is classified as non-blocking unless it reveals a concrete
  code/test/security defect.

## Immediate Next Actions

1. Re-run `scripts/validate-sale-readiness.R`.
2. Commit the refreshed sale package.
3. Refresh PR #92 remote workflow evidence in the validation appendix when the
   handover commit SHA changes or the buyer requires GitHub-hosted CI proof.
