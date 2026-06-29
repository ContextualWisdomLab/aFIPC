## 2024-06-27 - [Infinite Recursion DoS in Non-Interactive Environments]
**Vulnerability:** The legacy `readline()` prompts use unbounded recursion on invalid inputs, causing a C stack overflow (DoS) when executed in headless/CI environments.
**Learning:** Automated/non-interactive execution environments supply `""` or `EOF` to `readline()`, which fails validation regexes and triggers the infinite recursion loop.
**Prevention:** Always wrap interactive prompts with `interactive()` checks and provide safe, deterministic default fallbacks for headless execution.
