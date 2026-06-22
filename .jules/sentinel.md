## 2026-06-21 - Sentinel: Prevent DoS in non-interactive environments
**Vulnerability:** `readline()` prompts inside recursive helper functions (`checkCorrect`, `checkoldformBILOGprior`, `checknewformBILOGprior`) can block execution indefinitely or cause infinite recursion memory exhaustion if the code is executed in non-interactive environments like CI/CD pipelines or cron jobs.
**Learning:** R packages sometimes contain legacy interactive features that haven't been hardened for automation.
**Prevention:** Always use `interactive()` checks when requesting user input to gracefully handle execution in background/automated contexts.

## 2026-06-21 - Prevent DoS from infinite recursion in non-interactive environments
**Vulnerability:** The code used `readline()` recursively to prompt for user input. In non-interactive environments (e.g., CI/CD), `readline()` immediately returns `""`, causing an infinite recursion that leads to a stack overflow and Denial of Service.
**Learning:** R functions that require interactive input must explicitly check the environment using `interactive()` to prevent hanging or crashing automated processes.
**Prevention:** Always wrap interactive prompts (like `readline()`) with an `if (!interactive()) { return(default_value) }` check to provide a safe fallback in automated environments.
