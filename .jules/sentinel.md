## 2026-06-22 - Prevent infinite loops from readline in non-interactive sessions
**Vulnerability:** The code uses `readline()` in `R/aFIPC.R` to prompt the user. In non-interactive environments (e.g., CI/CD, automation scripts, agents), this causes infinite loops or hangs, leaving the process running and consuming resources.
**Learning:** `readline()` should only be used when `interactive()` is true. Interactive prompts are insecure and unstable in automated contexts because they block execution unconditionally.
**Prevention:** Always wrap `readline()` logic in an `if (interactive())` check or provide sensible defaults for non-interactive execution.
