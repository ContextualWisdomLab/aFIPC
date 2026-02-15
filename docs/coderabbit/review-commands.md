# CodeRabbit Review Commands

This repository uses `@coderabbitai` as the only bot reviewer mention target.

## Command placement rules

- Use in PR comments:
  - `@coderabbitai review`
  - `@coderabbitai full review`
  - `@coderabbitai pause`
  - `@coderabbitai resume`
  - `@coderabbitai resolve`
  - `@coderabbitai help`
- Use in PR description only:
  - `@coderabbitai ignore`

## Safe default workflow

1. Push branch updates.
2. Wait for required checks to finish.
3. Comment `@coderabbitai review`.
4. Resolve or answer actionable bot comments with evidence.
5. Comment `@coderabbitai full review` before merge when substantial changes
   were made.

## Notes

- Do not mention human reviewers by default.
- Treat bot feedback as hypotheses; verify with tests/logs before applying.
