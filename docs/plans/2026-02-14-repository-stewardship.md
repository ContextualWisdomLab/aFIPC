# Repository Stewardship Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use
> superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Restore baseline maintainability for the aFIPC repository
without changing calibration/linking behavior.

**Architecture:** Keep algorithmic code in `R/aFIPC.R` untouched and add
operational guardrails around it (docs, CI, security, dependency policy).
This separates scientific behavior from repository hygiene so future changes
remain auditable.

**Tech Stack:** R package tooling, GitHub Actions, Dependabot, Markdown docs

---

## Task 1: Establish architecture and agent guidance docs

**Files:**

- Create: `ARCHITECTURE.md`
- Create: `AGENTS.md`
- Create: `CLAUDE.md`
- Modify: `README.md`

**Steps:**

1. Document repository structure and component boundaries.
2. Capture non-negotiable maintenance guardrails for agents.
3. Add a Claude entrypoint that redirects to canonical guardrails.
4. Expand README with verification commands and maintenance policy.

## Task 2: Stabilize CI for current GitHub runner reality

**Files:**

- Modify: `.github/workflows/r.yml`
- Create: `LICENSE`

**Steps:**

1. Replace brittle matrix setup with stable R CMD check workflow.
2. Set non-interactive dependency installation path.
3. Pin all actions to full commit SHAs.
4. Add package license file required by `DESCRIPTION` metadata.

## Task 3: Add security and dependency governance automation

**Files:**

- Create: `.github/dependabot.yml`
- Create: `.github/workflows/codeql.yml`
- Create: `.github/workflows/dependency-review.yml`
- Create: `.github/workflows/scorecard.yml`

**Steps:**

1. Enable Dependabot updates for GitHub Actions.
2. Add CodeQL workflow for repository automation surface.
3. Add dependency review gate on pull requests.
4. Add Scorecard workflow and upload SARIF evidence.

## Task 4: Verify and ship safely

**Files:**

- Verify: changed workflow and docs files

**Steps:**

1. Run filetype lint checks for Markdown and workflows.
2. Run repository status/diff review to verify scoped changes.
3. Commit and push with auditable message focused on operational hardening.
