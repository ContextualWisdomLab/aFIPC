# AGENTS.md

## Mission

Maintain this repository as a stable, reproducible R package for fixed-item
parameter calibration and test linking.

## Non-negotiable guardrails

1. Preserve historical numerical behavior in `R/aFIPC.R` unless there is
   explicit regression evidence and maintainer intent to change behavior.
2. Treat CI/security/docs hygiene as first-class maintenance work.
3. Keep changes minimal and auditable; prefer additive guardrails over broad
   refactoring.

## Required maintenance checks

- Keep `.github/workflows/` green and action SHAs pinned.
- Keep `.github/dependabot.yml` active for GitHub Actions updates.
- Keep `ARCHITECTURE.md` up to date when structure changes.
- Keep README accurate for local verification commands.

## Editing priorities

1. Safety and reproducibility
2. CI reliability
3. Documentation clarity
4. Feature changes

## High-risk areas

- `R/aFIPC.R` contains long legacy logic with interactive prompts.
- Any changes around calibration/linking constraints can alter scientific output.

## Preferred change strategy

- Add tests/fixtures first when behavior changes are required.
- Isolate operational fixes (workflow/docs/dependency policy) from algorithmic
  edits.
- Document assumptions and risk in commit/PR summaries.

## Product design and Figma

- This repo has no frontend, route tree, Figma file, or implemented visual
  surface. Do not create UI code or visual artifacts unless a real product
  surface is introduced.
- Do not call future Figma work a "design system" unless it includes reusable
  foundations, tokens, components, states, accessibility guidance, and code
  mapping. Otherwise call it a UI kit, wireframe, or draft.

<!-- BEGIN cwl-agent-guidance -->
## Agent guidance (CWL governance)

Applies to every agent (Claude, Codex, Cursor, opencode, ...) working in this repo.

### Security & review gate

- Every PR runs a central **Security Scan** required check: `osv-scan` +
  `dependency-review` (diff-scoped) and `trivy-fs` (repo-wide, CRITICAL/HIGH,
  fixable only). It runs against each PR base, **including stacked PRs**.
- A failing `trivy-fs` is a **REAL finding, not a flake.** Read the job log (it
  prints each finding's rule id, severity, and file) or the run's SARIF results,
  then **remediate**: bump the offending R dependency (this package vendors its
  library tree under `packrat/`), or, only for a genuine false positive, add a
  narrow, path-scoped, commented entry to `.trivyignore.yaml`. Never weaken or
  disable the gate. This repo has no Dockerfile or k8s manifests, so misconfig
  findings are not expected; a hit here is a dependency or secret finding.
- The vendored packrat openssl docs include a verified false-positive example
  key at `packrat/lib/x86_64-pc-linux-gnu/3.4.1/openssl/doc/keys.html`; keep
  its `private-key` suppression path-scoped in `.trivyignore.yaml` and do not
  blanket-ignore the rule.
- A local `trivy` scan with a stale DB misses findings: run
  `trivy --download-db-only` first, and scan the **merge ref**, not just the PR head.
- The org `code_scanning` ruleset is intentionally **CodeQL-only** (multiple
  code-scanning tools cannot converge on one PR ref). Gating is by the Security
  Scan **job result**, not the `code_scanning` rule; do not add tools to that rule.

### Code exploration

- There is no `.codegraph/` index in this repo, so use normal search
  (grep/find) to locate and understand code. If a `.codegraph/` index is added
  later, prefer CodeGraph (`codegraph explore "<query>"` or the
  code-review-graph MCP tools) before grep/find; it surfaces callers, callees,
  and impact that text search misses.

### This repo's role in the ecosystem

- **aFIPC**: R IRT package for Fixed-Item Parameter Calibration; feeds
  fast-mlsirm's psychometrics.
- The org is an ecosystem around **naruon** (the hub: an email/PIM app that
  DOM-decomposes emails and files into a persisted knowledge graph). Every
  component is a **standalone program that must ALSO work as a git submodule**,
  grown separately and together.
- Sibling components: **waf-ids-ai-soc** (WAF/IDS/AI SOC/LB/APIM),
  **clearfolio** (document viewer), **pg-erd-cloud** (ERD tool),
  **contextual-orchestrator** (LLM cost/perf/upstream-LB gateway, beyond
  LiteLLM), **codec-carver** (STT/omni-modal speech-video codec),
  **fast-mlsirm** (LLM-as-a-Judge calibration + evaluation-item quality; uses
  aFIPC FIPC + kaefa item-fit), **feelanet-adfs** (passwordless SSO:
  OIDC/SCIM/ADFS/LDAP/FIDO2/OAuth2.1, eliminate passwords), **newsdom-api**
  (PDF to DOM sidecar), **semantic-data-portal** (upper ontology/catalog/governance
  plane with its own graph engine).

### Research grounding

- For substantive calibration/linking changes, cite the relevant IRT and
  psychometrics literature. Commit paper PDFs only when redistribution is
  permitted; otherwise cite, link, and summarize.
<!-- END cwl-agent-guidance -->
