#!/usr/bin/env bash
# Cloud Agent install step for the aFIPC R package.
#
# The R toolchain and CRAN dependencies (mirt, testthat, rcmdcheck, roxygen2)
# are normally already present in the prebuilt environment base image/snapshot.
# The guarded block below only runs on a bare image so this script stays
# idempotent and self-contained. R itself is pulled from the CRAN "release"
# channel (matching the r.yml CI), and CRAN packages come from r2u as prebuilt
# Ubuntu binaries so mirt does not have to be compiled from source.
set -euo pipefail

if ! command -v R >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends wget ca-certificates gnupg dirmngr

  # CRAN apt repo: release R for Ubuntu noble.
  wget -q -O- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
    | sudo tee /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc >/dev/null
  echo "deb [arch=amd64] https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/" \
    | sudo tee /etc/apt/sources.list.d/cran_r.list

  # r2u: prebuilt binary CRAN packages for Ubuntu noble.
  wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc \
    | sudo tee /etc/apt/trusted.gpg.d/cranapt_key.asc >/dev/null
  echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu noble main" \
    | sudo tee /etc/apt/sources.list.d/cranapt.list
  printf 'Package: *\nPin: release o=CRAN-Apt Project\nPin: release l=CRAN-Apt Packages\nPin-Priority: 700\n' \
    | sudo tee /etc/apt/preferences.d/99cranapt >/dev/null

  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends \
    r-base-core r-cran-mirt r-cran-testthat r-cran-roxygen2 r-cran-rcmdcheck pandoc
fi

# Install the checked-out aFIPC source into the R user library so that
# library(aFIPC) and the test suite run against the current tree.
USERLIB=$(R_PROFILE_USER=/dev/null Rscript -e 'cat(Sys.getenv("R_LIBS_USER"))')
mkdir -p "$USERLIB"
R_PROFILE_USER=/dev/null R CMD INSTALL --no-multiarch --no-staged-install -l "$USERLIB" .

echo "aFIPC install complete: R=$(R --version | head -1)"
