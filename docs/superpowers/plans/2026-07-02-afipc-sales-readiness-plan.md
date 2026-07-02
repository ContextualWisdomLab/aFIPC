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

- [ ] **Step 1: Replace placeholder with fallback implementation**

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

- [ ] **Step 2: Preserve API compatibility**

Keep the call-compatible arguments used by `R/aFIPC.R`:
`surveyFA(oldformYData, autofix = F, SE = T, forceUIRT = T, forceNormalEM = T, unstable = T, forceMHRM = T)`.

### Task 2: Add recovery/guardrails tests for `surveyFA`

**Files:**
- Replace: `tests/testthat/test-surveyFA.R`

- [ ] **Step 3: Add successful fallback test**

```r
set.seed(20260702)
raw <- as.data.frame(mirt::simdata(a = matrix(c(1.1, 1.2, 0.8), ncol = 3), d = c(-0.3, 0.2, 0.9), N = 200, itemtype = "2PL")
names(raw) <- paste0("item", 1:3)
# inject one constant item for robustness path
raw$item3 <- 1
fit <- aFIPC::surveyFA(raw, autofix = TRUE, forceUIRT = TRUE, SE = FALSE)
expect_s3_class(fit, "SingleGroupClass")
```

- [ ] **Step 4: Add malformed-input test**

```r
expect_error(aFIPC::surveyFA(1:10, forceUIRT = TRUE), "surveyFA requires a response matrix")
```

- [ ] **Step 5: Keep fallback guard tests in `testthat` index**

This file remains in the package test set and runs automatically with
`testthat::test_dir("tests/testthat")`.

### Task 3: Sync documentation for commercial completion criteria

**Files:**
- Modify: `docs/plans/2026-07-02-program-completion-baseline.md`
- Modify: `README.md`
- Modify: `man/surveyFA.Rd`

- [ ] **Step 6: Raise completion standard to commercial-ready**

Add `sales-ready` criteria for bounded fallback and explicit failed-recovery behavior.

- [ ] **Step 7: Update `surveyFA` contract in README**

Document that `surveyFA` now implements bounded fallback instead of immediate stop.

- [ ] **Step 8: Align `.Rd` signature to source**

Manual sync of usage/arguments/value so `roxygen2` consumers are consistent.

### Task 4: Dry-run validation gates before handoff

- [ ] **Step 9: Verify diff scope and syntax**

```bash
cd /Users/seonghobae/Documents/Codex/2026-07-02/https-github-com-contextualwisdomlab-afipc-figma
git diff --stat
```

- [ ] **Step 10: Review for explicit blockers not in scope**

No changes to `R/aFIPC.R` core algorithm beyond call-compatibility behavior.

### Task 5: Handoff to execution block

**Files:**
- None (handoff note)

- [ ] **Step 11: Register and publish next goal state**

Keep execution goal focused on commercial readiness and keep review-bot availability out of blocking criteria.

