# aFIPC Sales-Readiness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use
> superpowers:subagent-driven-development (recommended) or
> superpowers:executing-plans to execute this plan task-by-task.

**Goal:** Complete the package to a sellable operational baseline by implementing a bounded `surveyFA()` recovery path with deterministic behavior contracts and regression proof.

**Architecture:** Add a standalone fallback engine in `R/surveyFA.R` that is explicitly constrained to `mirt`-native estimation paths already used by `autoFIPC()`, keep API-compatible call signatures, and gate behavior changes with targeted tests.

**Tech Stack:** R, `mirt`, `testthat`, GitHub Workflows.

---

### Task 1: Implement bounded `surveyFA()` fallback engine

**Files:**
- Modify: `R/surveyFA.R`

- [x] **Step 1: Replace placeholder with fallback implementation**

Implement:

```r
# Accepts legacy args: autofix, forceUIRT, forceNormalEM, forceMHRM, unstable
# Returns: fitted mirt model on success
# Behavior:
# - Validate input matrix/data frame
# - Try EM/QMCEM/MHRM in bounded order
# - Optionally remove lowest-fit items in bounded autofix loop
# - Stop with explicit message when recovery exhausted
```

- [x] **Step 2: Preserve API compatibility**

Keep the call-compatible arguments used by `R/aFIPC.R`:
`surveyFA(oldformYData, autofix = F, SE = T, forceUIRT = T, forceNormalEM = T, unstable = T, forceMHRM = T)`.

### Task 2: Add recovery/guardrails tests for `surveyFA`

**Files:**
- Replace: `tests/testthat/test-surveyFA.R`

- [x] **Step 3: Add successful fallback test**

```r
set.seed(20260702)
raw <- as.data.frame(
  mirt::simdata(
    a = matrix(c(
      1.00, 1.20, 0.95, 1.08, 1.12,
      0.90, 1.05, 1.18, 1.22, 0.88
    ), ncol = 1),
    d = c(-1.0, -0.45, -0.10, 0.30, 0.70, -0.65, 0.20, 0.55, 0.95, -0.30),
    itemtype = rep("2PL", 10),
    N = 200
  )
)
names(raw) <- paste0("item", seq_len(ncol(raw)))
raw$item11 <- 1
fit <- aFIPC::surveyFA(raw, autofix = TRUE, forceUIRT = TRUE, forceNormalEM = TRUE, SE = FALSE)
expect_true(inherits(fit, "SingleGroupClass"))
```

- [x] **Step 4: Add malformed-input test**

- [x] **Step 4b: Add explicit unrecoverable fallback test**

```r
expect_error(aFIPC::surveyFA(1:10, forceUIRT = TRUE), "surveyFA requires a response matrix")
```

- [x] **Step 5: Keep fallback guard tests in `testthat` index**

This file remains in the package test set and runs automatically with
`testthat::test_dir("tests/testthat")`.

### Task 3: Sync documentation for commercial completion criteria

**Files:**
- Modify: `docs/plans/2026-07-02-program-completion-baseline.md`
- Modify: `README.md`
- Modify: `man/surveyFA.Rd`

- [x] **Step 6: Raise completion standard to commercial-ready**

Add `sales-ready` criteria for bounded fallback and explicit failed-recovery behavior.

- [x] **Step 7: Update `surveyFA` contract in README**

Document that `surveyFA` now implements bounded fallback instead of immediate stop.

- [x] **Step 8: Align `.Rd` signature to source**

Manual sync of usage/arguments/value so `roxygen2` consumers are consistent.

### Task 4: Dry-run validation gates before handoff

- [x] **Step 9: Verify diff scope and syntax**

```bash
cd /Users/seonghobae/Documents/Codex/2026-07-02/https-github-com-contextualwisdomlab-afipc-figma
git diff --stat
```

- [x] **Step 10: Review for explicit blockers not in scope**

No changes to `R/aFIPC.R` core algorithm beyond call-compatibility behavior.

### Task 5: Handoff to execution block

**Files:**
- None (handoff note)

- [x] **Step 11: Register and publish next goal state**

Keep execution goal focused on commercial readiness and keep review-bot availability out of blocking criteria.
