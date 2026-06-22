## 2026-06-21 - Sentinel: Prevent DoS in non-interactive environments
**Vulnerability:** `readline()` prompts inside recursive helper functions (`checkCorrect`, `checkoldformBILOGprior`, `checknewformBILOGprior`) can block execution indefinitely or cause infinite recursion memory exhaustion if the code is executed in non-interactive environments like CI/CD pipelines or cron jobs.
**Learning:** R packages sometimes contain legacy interactive features that haven't been hardened for automation.
**Prevention:** Always use `interactive()` checks when requesting user input to gracefully handle execution in background/automated contexts.
