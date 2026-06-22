## 2026-06-21 - Prevent DoS from infinite recursion in non-interactive environments
**Vulnerability:** The code used `readline()` recursively to prompt for user input. In non-interactive environments (e.g., CI/CD), `readline()` immediately returns `""`, causing an infinite recursion that leads to a stack overflow and Denial of Service.
**Learning:** R functions that require interactive input must explicitly check the environment using `interactive()` to prevent hanging or crashing automated processes.
**Prevention:** Always wrap interactive prompts (like `readline()`) with an `if (!interactive()) { return(default_value) }` check to provide a safe fallback in automated environments.
