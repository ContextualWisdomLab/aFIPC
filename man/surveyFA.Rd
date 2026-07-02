\name{surveyFA}
\alias{surveyFA}
\title{surveyFA}
\usage{
surveyFA(data, autofix = TRUE, forceUIRT = TRUE, forceNormalEM = FALSE,
  forceMHRM = FALSE, unstable = FALSE, SE = TRUE, itemtype = "2PL",
  maxItemRemovals = 3L, pThreshold = 0.05, ...)
}
\arguments{
\item{data}{A response matrix or data frame.}
\item{autofix}{When TRUE, remove least-fitting items and retry calibration.}
\item{forceUIRT}{Kept for legacy compatibility; fallback requires TRUE.}
\item{forceNormalEM}{Force normal EM/MMLE estimation for fallback attempts.}
\item{forceMHRM}{Force MHRM-based estimation for fallback attempts.}
\item{unstable}{Use a permissive estimator sequence including QMCEM and MHRM.}
\item{SE}{Whether to request standard errors from `mirt`.}
\item{itemtype}{IRT item type for fallback estimation.}
\item{maxItemRemovals}{Maximum number of items to remove in autofix mode.}
\item{pThreshold}{p-value cutoff for selecting misfitting items.}
\item{...}{Arguments passed to the function}
}
\description{
Fallback calibration helper used when direct `autoFIPC()` estimation fails.
}
\value{
A fitted `mirt` model object.
}
