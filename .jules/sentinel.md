## 2024-06-28 - [Stack Overflow DoS in Interactive Prompts]
**Vulnerability:** Recursive calls to `readline()` in `checkCorrect()`, `checkoldformBILOGprior()`, and `checknewformBILOGprior()` without bounding.
**Learning:** In R, unchecked recursive function calls, especially for user input loops, can cause a C stack overflow, leading to a Denial of Service (session crash).
**Prevention:** Use iterative `while` loops instead of recursion for repeatedly prompting users until valid input is received.
