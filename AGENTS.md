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
