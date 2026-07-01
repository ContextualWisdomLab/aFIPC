# Regression Fixture Replacement Note

## Decision

PR #87 should be replaced rather than repaired in place.

The markdown failure in PR #87 is mechanical, but the IPD test asserts that a
specific drifted anchor must be removed from `IPDCommonItemList`. Current CI
evidence showed that `autoFIPC()` retained that anchor while still exercising
the IPD filtering path. Changing `R/aFIPC.R` to satisfy that assertion would be
an algorithmic behavior change without maintainer-approved regression evidence.

## Replacement Scope

This branch keeps the regression lane additive:

- fixture-backed prior-update coverage for free-mean versus fixed-normal
  linking;
- fixture-backed IPD coverage that verifies filtered anchors are the anchors
  subsequently fixed in the linked model;
- no changes to `R/aFIPC.R` numerical behavior;
- no Figma Code Connect usage.

Exact drift classification for synthetic IPD anchors remains a follow-up
algorithmic task and should not be folded into duplicate queue triage.
