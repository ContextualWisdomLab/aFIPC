# ADR-0003: IPD/DIF screening is delegated to mirt

- Status: Accepted
- Date: 2026-08-16
- Deciders: maintainers

## Context

`autoFIPC()` can optionally screen common items for item parameter
drift (IPD) before the FIPC copy-and-fix step (`checkIPD`, default
true). The implementation builds a two-group response matrix and calls
`mirt::multipleGroup` plus `mirt::DIF`. Items flagged by that screen
may be dropped from the anchor set.

That workflow is an operational convenience around `mirt`. It is not
itself a published invariance, DIF, or IPD methodology paper, and it
must not be documented as one.

## Decision

Treat IPD/DIF screening as delegated `mirt` machinery:

- When `checkIPD` is true, screening uses `mirt::multipleGroup` and
  `mirt::DIF` on the declared common items.
- Items retained after the screen become the anchors for the Kim
  (2006) FIPC contract (ADR-0001).
- Documentation may describe the calls and the effect on the anchor
  list. It must not present `autoFIPC()` as a new DIF/IPD statistic
  or as evidence that anchors are invariant in a testing-program
  sense.

## Alternatives considered

- **No IPD screen.** Callers can set `checkIPD = FALSE` and supply
  anchors they have already reviewed.
- **A package-local DIF/IPD statistic.** Would be a new methodological
  claim and a behavior change. Out of scope for documentation work
  and not present in `R/aFIPC.R`.
- **Citing a security standard (NIST, OWASP) for this control.**
  Those sources apply to security ADRs. IPD screening is a
  psychometric operations step, not a security control.

## Consequences

- IPD results inherit `mirt` defaults, version behavior, and the
  arguments `autoFIPC()` passes through. Changes in `mirt` can change
  which anchors survive.
- Reviewers should not treat a clean IPD screen as a published
  invariance argument (AERA, APA, & NCME, 2014).
- Tests that pin FIPC (anchors fixed to old-form values) are separate
  from any claim about the DIF screen's Type I error or power.

## Claim boundary

This ADR records delegation. It does not claim that the `mirt` DIF
screen equals a named published IPD procedure, that surviving anchors
are drift-free, or that linked scores are interchangeable. The linking
contract remains FIPC (ADR-0001); estimation remains `mirt` MML-EM
(ADR-0002).

## References

Chalmers, R. P. (2012). mirt: A multidimensional item response theory
package for the R environment. *Journal of Statistical Software,
48*(6), 1–29. <https://doi.org/10.18637/jss.v048.i06>

Kim, S. (2006). A comparative study of IRT fixed parameter calibration
methods. *Journal of Educational Measurement, 43*(4), 355–381.
<https://doi.org/10.1111/j.1745-3984.2006.00021.x>

American Educational Research Association, American Psychological
Association, & National Council on Measurement in Education. (2014).
*Standards for educational and psychological testing*. American
Educational Research Association.
