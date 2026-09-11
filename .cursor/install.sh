#!/usr/bin/env bash
# Cloud Agent install step for the aFIPC R package.
#
# Provisions CRAN-release R and the CRAN dependencies used by documented
# verification (mirt, testthat, rcmdcheck, roxygen2). This step must stay
# revision-agnostic: with environment builds, `install` is snapshotted and is
# not rerun on later checkouts, so this script must not `R CMD INSTALL` the
# current tree (that would freeze library(aFIPC) at the build revision).
# Agents should use testthat::test_local() / rcmdcheck against the checkout.
#
# R comes from the CRAN "release" channel (matching r.yml). CRAN packages
# come from r2u as prebuilt Ubuntu binaries so mirt is not compiled from source.
set -euo pipefail

toolchain_ready() {
  command -v R >/dev/null 2>&1 || return 1
  R_PROFILE_USER=/dev/null Rscript -e '
    pkgs <- c("mirt", "testthat", "roxygen2", "rcmdcheck")
    q(status = if (all(pkgs %in% rownames(installed.packages()))) 0 else 1)
  ' >/dev/null 2>&1
}

if ! toolchain_ready; then
  # shellcheck source=/dev/null
  . /etc/os-release
  ARCH="$(dpkg --print-architecture)"
  # CRAN's Ubuntu channel is "<codename>-cran40/" (e.g. noble-cran40).
  CRAN_SUITE="${VERSION_CODENAME}-cran40"

  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends wget ca-certificates gnupg dirmngr

  wget -q -O- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
    | sudo tee /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc >/dev/null
  echo "deb [arch=${ARCH}] https://cloud.r-project.org/bin/linux/ubuntu ${CRAN_SUITE}/" \
    | sudo tee /etc/apt/sources.list.d/cran_r.list

  wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc \
    | sudo tee /etc/apt/trusted.gpg.d/cranapt_key.asc >/dev/null
  echo "deb [arch=${ARCH}] https://r2u.stat.illinois.edu/ubuntu ${VERSION_CODENAME} main" \
    | sudo tee /etc/apt/sources.list.d/cranapt.list
  printf 'Package: *\nPin: release o=CRAN-Apt Project\nPin: release l=CRAN-Apt Packages\nPin-Priority: 700\n' \
    | sudo tee /etc/apt/preferences.d/99cranapt >/dev/null

  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends \
    r-base-core r-cran-mirt r-cran-testthat r-cran-roxygen2 r-cran-rcmdcheck pandoc
fi

echo "aFIPC toolchain ready: R=$(R --version | head -1)"
