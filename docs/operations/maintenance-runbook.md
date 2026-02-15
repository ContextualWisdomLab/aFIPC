# Maintenance Runbook

This runbook defines the minimum recurring operations for maintaining `aFIPC`
without changing historical numerical behavior by accident.

## Weekly cycle

1. Check open PR queue:
   - `gh pr list --state open --limit 50`
2. Rebase stale Dependabot PRs:
   - `for n in 1 2 3 4; do gh pr comment "$n" --body "@dependabot rebase"; done`
3. Verify required checks on active PRs:
   - `gh pr checks <PR_NUMBER> --required`

## Monthly cycle

1. Verify ruleset is still enforcing required checks:
   - `gh api repos/seonghobae/aFIPC/rules/branches/master`
2. Review recent workflow failures:
   - `gh run list --limit 30`
3. Confirm security toggles best-effort state:
   - `gh api -i repos/seonghobae/aFIPC/vulnerability-alerts`
   - `gh api repos/seonghobae/aFIPC/automated-security-fixes`
   - `gh api -i repos/seonghobae/aFIPC/dependency-graph/sbom`

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
