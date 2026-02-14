# Governance Hardening Phase 2 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to
> implement this plan task-by-task.

**Goal:** Complete repository governance for PR/Issue flow and practical
security-quality automation on a private GitHub repository.

**Architecture:** Keep algorithmic code unchanged and harden repository
operations through templates, ownership metadata, and quality checks.
Where GitHub Advanced Security is unavailable, provide private-repo-safe
fallback controls and keep evidence for unsupported features.

**Tech Stack:** GitHub Actions, GitHub templates, Markdown, YAML lint tooling

---

## Task 1: PR/Issue governance scaffolding

**Files:**

- Create: `.github/PULL_REQUEST_TEMPLATE.md`
- Create: `.github/ISSUE_TEMPLATE/bug_report.md`
- Create: `.github/ISSUE_TEMPLATE/feature_request.md`
- Create: `.github/ISSUE_TEMPLATE/config.yml`
- Create: `.github/CODEOWNERS`

**Steps:**

1. Add PR checklist focused on validation, risk, and behavior impact.
2. Add issue templates for bug and feature intake.
3. Disable blank issues to force structured issue capture.
4. Add CODEOWNERS coverage for core algorithm and CI/governance files.

## Task 2: Code quality automation

**Files:**

- Create: `.github/workflows/code-quality.yml`

**Steps:**

1. Add quality workflow for push/pull_request.
2. Run YAML lint, markdown lint, and workflow lint in CI.
3. Pin all action references by full commit SHA.

## Task 3: Documentation synchronization

**Files:**

- Modify: `README.md`
- Modify: `ARCHITECTURE.md`

**Steps:**

1. Add links to PR/Issue templates and ownership metadata.
2. Add new quality workflow to architecture map.
3. Keep onboarding docs consistent with operational reality.

## Task 4: Security feature state and evidence

**Files:**

- Verify: GitHub API state and workflow outcomes

**Steps:**

1. Attempt enabling supported security toggles by `gh api`.
2. Record unsupported features for private repo constraints.
3. Keep CI green by skipping unavailable GHAS-only checks.
