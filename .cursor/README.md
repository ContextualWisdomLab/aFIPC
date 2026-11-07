# Cloud Agent environment

This directory configures the Cursor Cloud Agent development environment for
`aFIPC`.

- `environment.json` runs `install.sh` after the repository is checked out.
- `install.sh` provisions CRAN-release R plus the CRAN dependencies used by
  documented verification (`mirt`, `testthat`, `roxygen2`, `rcmdcheck`) from
  [r2u](https://eddelbuettel.github.io/r2u/) prebuilt binaries. It is
  revision-agnostic: it never `R CMD INSTALL`s the current tree, because
  environment builds snapshot `install` and do not rerun it on later checkouts.

Reproducibility across agents is pinned by the environment-build snapshot; the
apt block in `install.sh` only reprovisions a bare image.

Run the documented checks against the checkout:

```bash
R_PROFILE_USER=/dev/null Rscript -e 'testthat::test_local()'
R_PROFILE_USER=/dev/null Rscript -e 'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"))'
```

Run a single test file with the `filter` argument (matches
`tests/testthat/test-<filter>.R`):

```bash
R_PROFILE_USER=/dev/null Rscript -e 'testthat::test_local(filter = "surveyFA")'
```

See `ARCHITECTURE.md` (sections 1 and 8) for how this fits the repository.

## Security

`install.sh` stores each repository key in its own keyring under
`/etc/apt/keyrings` and binds it to that repository with `signed-by`, so a key
can only vouch for its own source (no global `trusted.gpg.d` trust).
