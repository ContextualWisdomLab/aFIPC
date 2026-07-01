# aFIPC Maintenance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use
> superpowers:subagent-driven-development (recommended) or
> superpowers:executing-plans to implement this plan task-by-task. Steps use
> checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the aFIPC maintenance package into a queue-cleaning workflow
that preserves `autoFIPC()` numerical behavior while reducing duplicate PRs.

**Architecture:** Use live GitHub evidence as the control plane, Markdown docs
as the durable handoff, and FigJam as the visual planning surface. Algorithmic
changes are allowed only after deterministic regression evidence is present.

**Tech Stack:** R package, `mirt`, `testthat`, GitHub CLI, GitHub Actions,
Figma FigJam, Markdown.

## Global Constraints

- Figma Code Connect is forbidden.
- Do not call `get_code_connect_map`, `get_code_connect_suggestions`,
  `get_context_for_code_connect`, or the `figma-code-connect` skill.
- Do not change `R/aFIPC.R` numerical behavior without regression evidence.
- Keep algorithmic, security, performance, and documentation work separate.
- Prefer closing duplicated bot PRs over stacking overlapping changes.
- Refresh live GitHub state before executing any PR decision.
- If structural symbol tracing is needed, ask before running
  `codegraph init -i` because `.codegraph/` is absent.

---

### Task 1: Refresh The Queue Evidence

**Files:**

- Read: `AGENTS.md`
- Read: `ARCHITECTURE.md`
- Read: `README.md`
- Read: `docs/superpowers/specs/2026-07-02-afipc-maintenance-design.md`
- Modify: none

**Interfaces:**

- Consumes: GitHub repository `ContextualWisdomLab/aFIPC`
- Produces: current PR/issue evidence for Tasks 2-5

- [ ] **Step 1: Confirm the working branch**

```bash
git status --short --branch
```

Expected: branch is not `master`; for this package it should be
`codex/afipc-maintenance-planning` or another dedicated work branch.

- [ ] **Step 2: Confirm repository metadata**

```bash
gh repo view ContextualWisdomLab/aFIPC \
  --json nameWithOwner,defaultBranchRef,isPrivate,visibility,primaryLanguage,url
```

Expected: `defaultBranchRef.name` is `master` and `visibility` is `PUBLIC`.

- [ ] **Step 3: Capture compact PR state**

```bash
fields="number,title,updatedAt,headRefName"
fields="$fields,mergeStateStatus,reviewDecision"
fields="$fields,statusCheckRollup,url"
gh pr list --repo ContextualWisdomLab/aFIPC --state open --limit 100 \
  --json "$fields" \
  | jq -r '.[] | {
      number,
      title,
      headRefName,
      updatedAt,
      mergeStateStatus,
      reviewDecision,
      url,
      failingChecks: ([.statusCheckRollup[]? |
        select((.conclusion // "") == "FAILURE") | .name] | join(",")),
      pendingChecks: ([.statusCheckRollup[]? |
        select((.status // "") != "COMPLETED") | .name] | join(",")),
      successCount: ([.statusCheckRollup[]? |
        select((.conclusion // "") == "SUCCESS")] | length)
    } | [
      .number,
      .mergeStateStatus,
      .reviewDecision,
      .successCount,
      .failingChecks,
      .pendingChecks,
      .updatedAt,
      .headRefName,
      .title,
      .url
    ] | @tsv'
```

Expected: one line per open PR with failing checks visible. If the PR count
differs from the spec, update the execution notes before making decisions.

- [ ] **Step 4: Capture compact issue state**

```bash
gh issue list --repo ContextualWisdomLab/aFIPC --state open --limit 100 \
  --json number,title,updatedAt,labels,url
```

Expected: issue #44, #8, #7, and #6 are present unless live state changed.

- [ ] **Step 5: Commit only if evidence docs changed**

If Task 1 updates docs, commit those changes:

```bash
git add docs/superpowers
git commit -m "docs: record aFIPC maintenance planning evidence"
```

Expected: commit succeeds. Skip this step if no files changed.

### Task 2: Repair Or Replace Regression Fixture Coverage

**Files:**

- Read: `tests/testthat/test-fixed-parameter-calibration.R`
- Read: `tests/testthat/test-package-api.R`
- Candidate modify: files from PR #87 after inspecting its diff
- Candidate create: `tests/testthat/fixtures/*.R`

**Interfaces:**

- Consumes: PR #87 or a replacement branch
- Produces: deterministic coverage for prior-update behavior and IPD anchor
  filtering

- [ ] **Step 1: Inspect PR #87**

```bash
gh pr view 87 --repo ContextualWisdomLab/aFIPC \
  --json headRefOid,mergeStateStatus,reviewDecision,statusCheckRollup,files,url
```

Expected: current failing checks and changed files are visible.

- [ ] **Step 2: Fetch the PR patch**

```bash
gh pr diff 87 --repo ContextualWisdomLab/aFIPC > /tmp/afipc-pr-87.diff
```

Expected: `/tmp/afipc-pr-87.diff` exists and includes only test/docs changes or
clearly justified helper changes.

- [ ] **Step 3: Decide fix versus replacement**

Use this rule:

```text
If PR #87 changes only tests/docs and failures are mechanical, repair it.
If PR #87 changes algorithm behavior or has unclear generated code, recreate a
smaller regression-only branch and close #87 as superseded.
```

Expected: one written decision in the PR comment or local execution notes.

- [ ] **Step 4: Run local package tests**

```bash
R_PROFILE_USER=/dev/null Rscript -e 'testthat::test_dir("tests/testthat")'
```

Expected: PASS. If `mirt` is unavailable locally, record the dependency gap and
use CI as the authoritative execution environment.

- [ ] **Step 5: Run package check**

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "error")'
```

Expected: PASS or a documented environment-only failure that CI does not
reproduce.

- [ ] **Step 6: Commit the regression lane result**

```bash
git add tests docs
git commit -m "test: add aFIPC numerical regression fixtures"
```

Expected: one commit containing only regression evidence and related docs.

### Task 3: Select One Sentinel Security Fix

**Files:**

- Read: `R/aFIPC.R`
- Read: `tests/testthat/test-autoFIPC.R`
- Candidate modify: only the selected Sentinel branch changes

**Interfaces:**

- Consumes: Sentinel PRs #88, #86, #83, #82, #77, #74, #71
- Produces: one security fix path and a close list for duplicates

- [ ] **Step 1: Compare active Sentinel PRs**

```bash
for pr in 88 86 83 82 77 74 71; do
  gh pr view "$pr" --repo ContextualWisdomLab/aFIPC \
    --json number,title,mergeStateStatus,reviewDecision,url
done
```

Expected: one JSON object per Sentinel PR.

- [ ] **Step 2: Pick the candidate**

Use this rule:

```text
Prefer a branch that is approved or has resolvable changes requested, has no
failing required checks, and changes the fewest lines in the shared prompt or
retry path. Reject dirty branches unless their patch is materially better.
```

Expected: one selected PR number and a duplicate-close list.

- [ ] **Step 3: Verify the selected diff**

```bash
gh pr diff SELECTED_PR --repo ContextualWisdomLab/aFIPC
```

Expected: no broad refactor, no unrelated docs churn, and no numerical model
changes beyond bounded retry or non-interactive failure behavior.

- [ ] **Step 4: Run targeted tests**

```bash
R_PROFILE_USER=/dev/null Rscript -e 'testthat::test_file("tests/testthat/test-autoFIPC.R")'
```

Expected: PASS.

- [ ] **Step 5: Close duplicated Sentinel PRs after selected fix is accepted**

```bash
body="Superseded by the selected Sentinel DoS fix."
gh pr close DUPLICATE_PR --repo ContextualWisdomLab/aFIPC \
  --comment "$body"
```

Expected: duplicate PR closes with a clear reason. Do this only after the
selected security fix is merged or explicitly chosen by the maintainer.

### Task 4: Select One Bolt Performance Fix

**Files:**

- Read: `R/aFIPC.R`
- Read: `tests/testthat/test-fixed-parameter-calibration.R`
- Candidate modify: only the selected Bolt branch changes

**Interfaces:**

- Consumes: Bolt PRs #89, #85, #84, #81, #79, #76, #75, #73, #72
- Produces: one performance fix path and a close list for duplicates

- [ ] **Step 1: Compare active Bolt PRs**

```bash
for pr in 89 85 84 81 79 76 75 73 72; do
  gh pr view "$pr" --repo ContextualWisdomLab/aFIPC \
    --json number,title,mergeStateStatus,reviewDecision,url
done
```

Expected: one JSON object per Bolt PR.

- [ ] **Step 2: Pick the candidate**

Use this rule:

```text
Prefer one measured, narrow optimization after regression fixtures pass. Reject
dirty branches, duplicated fscores caching branches, and changes that combine
performance with unrelated non-interactive prompt behavior.
```

Expected: one selected PR number and a duplicate-close list.

- [ ] **Step 3: Verify behavior preservation**

```bash
R_PROFILE_USER=/dev/null Rscript -e 'testthat::test_file("tests/testthat/test-fixed-parameter-calibration.R")'
```

Expected: PASS and fixed common-item parameters remain equal to old-form values.

- [ ] **Step 4: Run full package check**

```bash
R_PROFILE_USER=/dev/null Rscript -e \
'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "error")'
```

Expected: PASS.

- [ ] **Step 5: Close duplicated Bolt PRs after selected fix is accepted**

```bash
body="Superseded by the selected Bolt optimization."
gh pr close DUPLICATE_PR --repo ContextualWisdomLab/aFIPC \
  --comment "$body"
```

Expected: duplicate PR closes with a clear reason. Do this only after the
selected optimization is merged or explicitly chosen by the maintainer.

### Task 5: Patch Maintainer Documentation

**Files:**

- Modify: `docs/operations/maintenance-runbook.md`
- Modify: `.github/PULL_REQUEST_TEMPLATE.md`
- Optional modify: `README.md`

**Interfaces:**

- Consumes: queue classification from Tasks 1-4
- Produces: maintainer-facing process for duplicate PR triage and Figma link
  retention

- [ ] **Step 1: Update repository owner commands**

Replace stale `seonghobae/aFIPC` command examples with
`ContextualWisdomLab/aFIPC` where the command targets this repository.

Expected: no stale owner appears in runbook command examples.

- [ ] **Step 2: Add PR category checklist**

Add this checklist to `.github/PULL_REQUEST_TEMPLATE.md`:

```markdown
## Change Category

- [ ] Regression evidence
- [ ] Security / DoS guardrail
- [ ] Performance optimization
- [ ] CI / governance
- [ ] Documentation only
- [ ] Other:
```

Expected: contributors must classify PR intent before review.

- [ ] **Step 3: Add duplicate-close rule**

Add this rule to `docs/operations/maintenance-runbook.md`:

```markdown
When multiple bot PRs touch the same `R/aFIPC.R` path for the same problem,
choose one candidate after live checks and diff review. Close older overlapping
PRs as superseded after the selected fix is merged or explicitly chosen.
```

Expected: maintainers have a clear close policy.

- [ ] **Step 4: Add FigJam artifact location**

Add the current FigJam planning link to the runbook:

```markdown
- aFIPC maintenance decision flow:
  https://www.figma.com/board/G6GNn2sGFJ19T8uFv9EtgI
```

Expected: the non-Code-Connect visual artifact is discoverable from repo docs.

- [ ] **Step 5: Validate docs**

```bash
markdownlint-cli2 \
  README.md AGENTS.md ARCHITECTURE.md CLAUDE.md CONTRIBUTING.md \
  .github/**/*.md docs/**/*.md
```

Expected: PASS. If `markdownlint-cli2` is missing, run
`npx markdownlint-cli2 ...` or rely on the Code Quality workflow.

- [ ] **Step 6: Commit documentation**

```bash
git add docs/operations/maintenance-runbook.md .github/PULL_REQUEST_TEMPLATE.md README.md
git commit -m "docs: clarify aFIPC maintenance triage flow"
```

Expected: one documentation-only commit.

### Task 6: Reassess Governance And Packrat Separately

**Files:**

- Read: `packrat/packrat.lock`
- Read: `README.md`
- Read: `ARCHITECTURE.md`
- Candidate create: `docs/plans/YYYY-MM-DD-packrat-migration.md`

**Interfaces:**

- Consumes: PR #80 and `packrat/` size evidence
- Produces: separate decision on governance and dependency modernization

- [ ] **Step 1: Recheck PR #80**

```bash
gh pr view 80 --repo ContextualWisdomLab/aFIPC \
  --json number,title,mergeStateStatus,reviewDecision,statusCheckRollup,url
```

Expected: confirm whether `opencode-review` still fails.

- [ ] **Step 2: Measure `packrat/`**

```bash
du -sh packrat
git ls-files 'packrat/**' | wc -l
```

Expected: current size and file count are recorded.

- [ ] **Step 3: Keep `packrat/` migration separate**

Use this rule:

```text
Do not remove or replace packrat in the same PR as queue triage, Sentinel,
Bolt, or regression fixture work. Create a dedicated migration proposal with
reproducibility rollback notes.
```

Expected: no `packrat/` deletion in the maintenance triage branch.

- [ ] **Step 4: Commit only if a migration proposal is written**

```bash
git add docs/plans
git commit -m "docs: propose packrat migration path"
```

Expected: optional docs-only commit.

### Task 7: Final Verification And Handoff

**Files:**

- Read: `docs/superpowers/specs/2026-07-02-afipc-maintenance-design.md`
- Read: `docs/superpowers/plans/2026-07-02-afipc-maintenance-plan.md`

**Interfaces:**

- Consumes: all prior task outputs
- Produces: final maintainer handoff

- [ ] **Step 1: Verify Code Connect was not used**

```bash
rg -n "get_code_connect|figma-code-connect|Code Connect" docs/superpowers
```

Expected: only prohibition text appears.

- [ ] **Step 2: Verify no algorithmic code changed in this planning pass**

```bash
git diff -- R/aFIPC.R tests
```

Expected: empty diff unless the user explicitly advanced from planning into
implementation.

- [ ] **Step 3: Verify docs exist**

```bash
test -f docs/superpowers/specs/2026-07-02-afipc-maintenance-design.md
test -f docs/superpowers/plans/2026-07-02-afipc-maintenance-plan.md
```

Expected: both commands exit with code 0.

- [ ] **Step 4: Verify final git state**

```bash
git status --short --branch
```

Expected: only intentional docs changes remain, or the branch is clean after
commits.

- [ ] **Step 5: Handoff**

Report:

```text
Spec path:
docs/superpowers/specs/2026-07-02-afipc-maintenance-design.md

Plan path:
docs/superpowers/plans/2026-07-02-afipc-maintenance-plan.md

FigJam:
https://www.figma.com/board/G6GNn2sGFJ19T8uFv9EtgI

Next recommended execution:
Task 1, then Task 2, then one Sentinel candidate.
```

Expected: maintainer has exact files, visual artifact, and next action.
