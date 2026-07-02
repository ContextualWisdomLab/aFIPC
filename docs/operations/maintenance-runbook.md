# Maintenance Runbook

This runbook defines the minimum recurring operations for maintaining `aFIPC`
without changing historical numerical behavior by accident.

## Weekly cycle

1. Check open PR queue:
   - `gh pr list --repo ContextualWisdomLab/aFIPC --state open --limit 50`
2. Rebase stale Dependabot PRs:

   ```bash
   gh pr comment <PR_NUMBER> --repo ContextualWisdomLab/aFIPC \
     --body "@dependabot rebase"
   ```

3. Verify required checks on active PRs:
   - `gh pr checks <PR_NUMBER> --repo ContextualWisdomLab/aFIPC --required`
4. Classify open bot PRs before acting:
   - regression evidence;
   - security / DoS guardrail;
   - performance optimization;
   - CI / governance;
   - documentation only.
5. When multiple bot PRs touch the same `R/aFIPC.R` path for the same
   problem, choose one candidate after live checks and diff review. Close older
   overlapping PRs as superseded only after the selected fix is merged or
   explicitly chosen by the maintainer.

## Monthly cycle

1. Verify ruleset is still enforcing required checks:
   - `gh api repos/ContextualWisdomLab/aFIPC/rules/branches/master`
2. Review recent workflow failures:
   - `gh run list --repo ContextualWisdomLab/aFIPC --limit 30`
3. Confirm security toggles best-effort state:
   - `gh api -i repos/ContextualWisdomLab/aFIPC/vulnerability-alerts`
   - `gh api repos/ContextualWisdomLab/aFIPC/automated-security-fixes`
   - `gh api -i repos/ContextualWisdomLab/aFIPC/dependency-graph/sbom`

## Planning artifacts

- aFIPC maintenance decision flow:
  <https://www.figma.com/board/G6GNn2sGFJ19T8uFv9EtgI>
- Local planning spec:
  `docs/superpowers/specs/2026-07-02-afipc-maintenance-design.md`
- Local execution plan:
  `docs/superpowers/plans/2026-07-02-afipc-maintenance-plan.md`

## Release-quality gate

Before merging operational changes, run:

- `python3 -m yamllint .yamllint.yml .github/dependabot.yml .github/workflows/*.yml`
- `actionlint`
- `Rscript -e 'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"),
  error_on = "error")'`

## Risk policy

- Do not make algorithmic changes in `R/aFIPC.R` without explicit regression
  evidence.
- If a bot requests broad behavioral refactoring, split into a dedicated PR with
  reproducibility fixtures first.
- Do not remove or replace `packrat/` in the same PR as queue triage, Sentinel,
  Bolt, regression fixture, or governance work. Create a dedicated migration
  proposal with reproducibility rollback notes first.
- As of 2026-07-02, `packrat/` is 58 MB and 1,876 tracked files. Treat this as
  dependency-modernization scope, not queue-cleanup scope.
- PR #80 (`chore: add OpenSSF readiness baseline`) is governance-only and
  currently separate from `packrat/`; resolve its OpenCode review/check state
  independently from dependency migration.
