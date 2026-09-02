# Architecture decision records

This folder records methodological and estimation decisions for `aFIPC`.
Each ADR states a contract, the alternatives considered, and a claim
boundary so maintainers do not treat orchestration in this package as a
new psychometric method.

Use `0000-template.md` for new records. Status values are Proposed,
Accepted, Deprecated, or Superseded. Do not invent bibliographic records;
cite verified sources only.

These ADRs are documentation. They do not change `autoFIPC()` numerical
behavior.

## Index

| ID | Title | Status |
| --- | --- | --- |
| [ADR-0001](0001-fipc-linking-contract.md) | FIPC as the linking contract | Accepted |
| [ADR-0002](0002-mirt-mml-em-engine.md) | mirt as the estimation engine | Accepted |
| [ADR-0003](0003-ipd-dif-screening-delegation.md) | IPD/DIF screening is delegated to mirt | Accepted |

## Related documents

- Linking contract restatement:
  [`docs/fixed-parameter-item-calibration.md`](../fixed-parameter-item-calibration.md)
- Source-paper list with DOIs: [`docs/papers/README.md`](../papers/README.md)
- Repository map: [`ARCHITECTURE.md`](../../ARCHITECTURE.md)
