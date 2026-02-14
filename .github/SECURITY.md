# Security Policy

## Supported Versions

This project is currently maintained as a single active line on the default
branch.

| Version | Supported |
| --- | --- |
| default branch (`master`/`main`) | yes |
| historical tags/commits | no |

## Reporting a Vulnerability

Please do not open public issues for security vulnerabilities.

Use one of the following private channels:

- GitHub private vulnerability reporting for this repository
- Email: `seongho@kw.ac.kr`

When reporting, include:

- affected file/path and commit SHA (if known)
- reproduction steps
- expected impact (confidentiality, integrity, availability)

## Response Targets

- Initial triage acknowledgment: within 7 days
- Status update after triage: within 14 days
- Fix timeline: depends on severity and reproducibility

## Security Scope Notes

- This repository is an R package for IRT linking calculations; it is not an
  internet-facing service.
- High-priority risks include supply-chain integrity (Actions/dependencies),
  accidental secret disclosure, and unsafe CI automation changes.
