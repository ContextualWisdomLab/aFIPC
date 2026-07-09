## 2024-06-23 - 재귀적 입력 검증으로 인한 대화형 프롬프트 DoS 취약점
**Vulnerability:** 대화형 프롬프트 함수(`checkCorrect`, `checkoldformBILOGprior`, `checknewformBILOGprior`)에서 사용자가 올바르지 않은 값(예: 숫자가 아닌 문자열)을 입력했을 때, 꼬리 재귀(tail-recursive) 방식으로 자기 자신을 호출하도록 구현되어 있었습니다. 이는 R의 C 스택 사이즈 제한으로 인해 스택 고갈(Stack Exhaustion)로 이어지는 DoS(서비스 거부) 취약점을 야기할 수 있으며, `readline()`이 계속 빈 문자열을 반환하는 비대화형(non-interactive) CI/CD 환경에서는 무한 루프를 발생시켰습니다.
**Learning:** 입력 검증 루프는 재귀 호출을 사용하여 구현해서는 안 되며, 특히 자동화된 환경에서 입력이 제공될 때 더욱 주의해야 합니다. 비대화형 세션에서의 탈출구(escape hatch)가 없는 재귀적 입력 루프는 리소스를 즉시 고갈시켜 자동화된 테스트 및 CI 환경을 손상시킵니다.
**Prevention:**
1. 입력 검증 시 재귀 호출 대신 `repeat` 루프를 사용합니다.
2. 수동 입력을 요구하기 전에 항상 `!interactive()`를 사용하여 현재 세션이 대화형인지 확인하고, 비대화형 세션일 경우에는 즉시 에러를 발생시켜 안전하게 실패(fail securely)하도록 처리합니다.
3. common item 확인처럼 추정 결과의 기준척도와 true parameter 재현에 직접 영향을 주는 입력은 비대화형 환경에서 기본값으로 자동 승인하지 않습니다. 자동화에서는 `confirmCommonItems = TRUE`처럼 명시적 opt-in을 요구합니다.
4. 대화형 재입력 루프도 무한 반복하지 않도록 제한된 횟수만 허용하고, 초과 시 명확한 에러로 종료합니다.
5. DoS 완화를 위해 `return(1L)` 같은 기본 승인값을 넣을 때는 추정 기준척도, anchor/common item, true parameter 재현 계약을 우회하지 않는지 먼저 검증합니다.
6. Fail-secure 에러 메시지는 테스트의 일부로 취급합니다. 보안 테스트는 실제 구현 메시지와 맞아야 하며, 오래된 `"Interactive prompt is not available"` 같은 별도 문구를 새로 만들지 않습니다.
7. Prompt DoS 회귀 테스트는 모델 추정 실패에 기대지 말고, common-item confirmation guard처럼 취약한 입력 경계에서 바로 발생하는 fail-secure 에러를 검증합니다.

## 2024-06-25 - Unbounded Loop in Model Retry (Infinite Loop DoS)
**Vulnerability:** When the initial `mirt::mirt()` model estimation failed, the code utilized an unconstrained `while (!exists('model'))` loop to continually attempt re-estimation. Since R's deterministic errors inside `try()` would repetitively fail without side-effects altering the outcome, this created an infinite loop Denial of Service (DoS) in automated environments.
**Learning:** Deterministic failure handling must never rely on unbounded loops. Relying on `try()` combined with `while (!exists(...))` assumes transient errors, which is often not true for statistical model convergence issues.
**Prevention:**
1. Always replace `while (!exists(...))` retries with a bounded `for` loop (e.g., `for (attempt in seq_len(3))`).
2. Include an explicit check for the success condition inside the loop (`if (exists('model')) break`).
3. After the loop, verify success and fail securely with an explicit error (`if (!exists('model')) stop(...)`) to prevent unhandled exceptions downstream.

## 2024-06-26 - Vector Wipeout due to Multiple Negative grep() Outputs
**Vulnerability:** In `R/aFIPC.R`, multiple negative `grep()` outputs were combined using `-c(grep(...), ...)` to filter a vector of parameter names. If none of the `grep()` patterns match any elements in the vector, `grep()` returns an empty integer vector `integer(0)`. Combining multiple `integer(0)` results in `integer(0)`. Subsetting a vector with `-integer(0)` (e.g., `vector[-integer(0)]`) returns an empty vector (`character(0)` or similar, depending on type), silently wiping out the entire vector contents and causing downstream logic failures.
**Learning:** Using `grep()` with negative indices (`-c(...)`) is inherently unsafe in base R when the possibility exists that no matches will be found. This pattern leads to silent and unpredictable state corruption because it effectively removes all elements instead of preserving them.
**Prevention:**
1. Never use `-c(grep(...), ...)` to exclude elements from a vector.
2. Always use the negation of `grepl()` (e.g., `!grepl("^(pattern1|pattern2)", vector)`) which safely returns a logical vector. If there are no matches, it returns a vector of `TRUE`s, safely preserving the original vector when subsetted.

## 2024-07-05 - Missing Input Validation
**Vulnerability:** The `autoFIPC` function lacked explicit input validation for core arguments like `newformXData`, `oldformYData`, `newformCommonItemNames`, and `itemtype`. When unexpected types (e.g. integer `1` instead of a data structure, or an array for `itemtype`) were provided, the errors propagated dynamically causing unhandled downstream exceptions or potential state leaks depending on internal implementations (like `mirt` and `try` blocks capturing objects unexpectedly). Furthermore, if the base model estimation `try(mirt(...))` entirely failed to produce a model object, the code would later crash when trying to access `@OptimInfo`, leading to untracked exceptions.
**Learning:** In dynamically typed environments like R, trusting user inputs without explicit runtime validation boundaries allows malformed types to flow deeply into internal logic. This can result in obscure failure modes, leakage of unhandled stack exceptions, or unpredictable behavior across statistical dependencies.
**Prevention:**
1. Always enforce explicit boundary checks on public-facing functions (e.g., verifying `is.data.frame`, `is.matrix`, or custom class types).
2. Fail fast and securely with explicit "Security Error" messages when the data contract is violated, before passing data to third-party statistical engines.
3. When using `try()` to swallow errors on initial setup, immediately verify the expected object (`exists("model")`) was actually created before accessing its slots or attributes.

## 2024-07-07 - Unhandled Exception Leakage Downstream
**Vulnerability:** `try()` block 이후에 반환된 객체가 실제로 존재하는지(성공했는지) 검증하지 않고 해당 객체의 프로퍼티(`@OptimInfo$secondordertest`)에 바로 접근하는 패턴이 여러 곳에 존재했습니다. 추정이 실패하여 에러가 발생한 경우 변수가 생성되지 않거나 기존 변수가 유지되어 의도치 않은 예외나 내부 상태 노출을 발생시킵니다.
**Learning:** `try()`를 통한 예외 처리는 에러를 억제할 뿐, 결과 객체의 존재를 보장하지 않습니다. 실패한 동작의 결과를 가정하고 후속 코드를 실행하면 치명적인 예외가 발생할 수 있습니다.
**Prevention:**
1. `try()` 블록 외부에서 결과 객체를 사용할 때는 항상 해당 객체가 생성되었는지 확인해야 합니다 (`exists('model')`).
2. 객체의 프로퍼티에 안전하게 접근하려면, 객체가 존재하고 예상되는 타입인지 검증하는 로직을 결합해야 합니다 (예: `(!exists('model') || !isTRUE(model@OptimInfo$secondordertest))`).

## 2024-07-09 - CI Failure: Trivy False Positives in Vendored Dependencies
**Vulnerability:** Trivy Secret scanner incorrectly flagged `HIGH` severity `AsymmetricPrivateKey` vulnerabilities inside `packrat/lib/.../openssl/doc/keys.html`. These are example keys inside HTML documentation of a vendored library, not live credentials.
**Learning:** Security scanners like Trivy can produce false positives when scanning vendored dependencies, test fixtures, or documentation containing example secrets. This can break CI pipelines.
**Prevention:**
1. Suppress only the known false-positive file path with `trivy.yaml` `scan.skip-files`, especially in vendored directories like `packrat/`.
2. Keep suppressions path-scoped and never globally disable the secret rule for all vendored code.
