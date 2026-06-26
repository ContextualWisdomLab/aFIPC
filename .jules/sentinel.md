## 2024-06-26 - [Interactive Prompt DoS Fix]
**Vulnerability:** Legacy interactive `readline()` prompts caused automated processes to hang indefinitely in non-interactive environments, leading to a Denial of Service (DoS) risk for build and automation pipelines.
**Learning:** `readline()` and similar functions MUST handle non-interactive contexts. R provides `interactive()` to detect non-interactive execution. Infinite recursion or hanging can be prevented by providing sensible defaults.
**Prevention:** Always wrap interactive input requests in `if (!interactive()) return(default_value)`. Ensure no recursive function calls that depend solely on human input are used without safeguards.
