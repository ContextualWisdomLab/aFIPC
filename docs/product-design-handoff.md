# Product Design Handoff

This repository is an R package, not a web or mobile product. There is no
first-party frontend code, route tree, Figma file, or implemented visual page in
the repository today. Until that changes, visual design work is limited to the
package user journey, documentation structure, and any future UI wrapper around
`autoFIPC()`.

## Information Architecture

- Home / README: package purpose, trusted maintenance policy, and quick check
  command.
- Method basis: fixed parameter item calibration basis and references.
- API reference: `autoFIPC()` arguments, return object, and generated Rd docs.
- Regression evidence: true-parameter reproduction and Hessian stability tests.
- Operations: CI, security, review, and maintainer runbooks.

## Screen Definition

If a UI is added later, it must cover these screens before being called a
product interface.

| Screen | Purpose | Primary content | Required state |
| --- | --- | --- | --- |
| Method overview | Explain why fixed parameters define the base scale. | Formula summary, references, assumptions. | Empty state links to sample data. |
| Calibration setup | Collect old/new responses and common-item mapping. | File/data inputs, model options, validation messages. | Invalid mappings block run. |
| Run status | Show calibration progress and failures. | Current step, warnings, convergence status. | Failed estimation exposes diagnostics. |
| Results review | Inspect linked parameters and score/theta outputs. | Parameter table, common-item lock indicators, export actions. | Hessian/vcov warning is visible. |
| Evidence | Prove the result is trustworthy. | True-parameter recovery, `vcov`, `secondordertest`, test command. | Missing evidence blocks publish. |

## Key Screen

The key screen is Results review. A maintainer must be able to see, without
opening raw R objects, whether common-item parameters stayed fixed and whether
the linked model has finite covariance and a passing second-order check.

## Wireframe

```text
+---------------------------------------------------------------+
| aFIPC Results Review                                          |
+----------------------+----------------------------------------+
| Run summary          | Linked parameter table                 |
| - old form model     | item | role | a1 | d | estimated?      |
| - new form model     | ---- | ---- | -- | - | ----------      |
| - common items       | i01  | common | .. | . | no            |
| - convergence        | i09  | new    | .. | . | yes           |
+----------------------+----------------------------------------+
| Evidence                                                      |
| [pass] true-parameter recovery                                |
| [pass] finite Hessian-derived vcov                            |
| [pass] secondordertest                                        |
+---------------------------------------------------------------+
```

## User Stories

- As a psychometric analyst, I want common-item parameters to remain fixed so
  new-form estimates stay on the old-form scale.
- As a package maintainer, I want automated true-parameter reproduction tests so
  refactors cannot silently change calibration behavior.
- As a reviewer, I want Hessian-derived covariance and second-order evidence so
  a passing run is numerically stable, not just free of thrown errors.
- As a future UI user, I want invalid common-item mappings to fail before model
  fitting so I do not interpret a mislinked result.

## Build Rule

Do not create frontend code for aFIPC unless a real UI target is introduced.
When a UI target exists, this document is the minimum product-design contract:
IA, screen definitions, key screen, wireframe, and user stories must be updated
with the code and reviewed before merge.
