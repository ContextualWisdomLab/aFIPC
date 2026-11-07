#' @title surveyFA
#' @description Fallback calibration helper used when direct model estimation in
#'   `autoFIPC()` fails.
#' @param data A response matrix or data frame.
#' @param autofix When TRUE, remove least-fitting items and retry calibration.
#' @param forceUIRT Kept for legacy compatibility; the fallback is only executed
#'   in this mode.
#' @param forceNormalEM Force normal EM/MMLE estimation for the fallback attempt.
#' @param forceMHRM Force MHRM-based estimation when other approaches fail.
#' @param unstable Apply a more permissive retry sequence including QMCEM/MHRM.
#' @param SE Whether to request standard errors from `mirt`.
#' @param itemtype IRT item type for fallback estimation.
#' @param maxItemRemovals Maximum number of items to remove in autofix mode.
#' @param pThreshold p-value cutoff for selecting the first misfit item.
#' @param ... Additional arguments reserved for compatibility.
#' @return A fitted `mirt` model object with finite log-likelihood and, when
#'   `SE = TRUE`, a passing second-order test plus finite covariance estimates.
#' @export
surveyFA <- function(
  data,
  autofix = TRUE,
  forceUIRT = TRUE,
  forceNormalEM = FALSE,
  forceMHRM = FALSE,
  unstable = FALSE,
  SE = TRUE,
  itemtype = "2PL",
  maxItemRemovals = 3L,
  pThreshold = 0.05,
  ...
) {
  validate_logical_scalar <- function(value, name) {
    if (!is.logical(value) || length(value) != 1L || is.na(value)) {
      stop(
        sprintf("Security Error: %s must be a single non-NA logical value", name),
        call. = FALSE
      )
    }
  }

  validate_logical_scalar(autofix, "autofix")
  validate_logical_scalar(forceUIRT, "forceUIRT")
  validate_logical_scalar(forceNormalEM, "forceNormalEM")
  validate_logical_scalar(forceMHRM, "forceMHRM")
  validate_logical_scalar(unstable, "unstable")
  validate_logical_scalar(SE, "SE")

  if (!forceUIRT) {
    stop(
      "surveyFA requires forceUIRT=TRUE; fallback requires explicit legacy-mode activation.",
      call. = FALSE
    )
  }

  if (!is.data.frame(data) && !is.matrix(data)) {
    stop("surveyFA requires a response matrix or data frame.", call. = FALSE)
  }

  if (!is.character(itemtype) || length(itemtype) != 1L || is.na(itemtype)) {
    stop("surveyFA requires itemtype to be a single non-NA character value.", call. = FALSE)
  }

  if (
    !is.numeric(maxItemRemovals) ||
      length(maxItemRemovals) != 1L ||
      is.na(maxItemRemovals) ||
      maxItemRemovals < 0
  ) {
    stop("surveyFA requires maxItemRemovals to be a non-negative numeric scalar.", call. = FALSE)
  }
  maxItemRemovals <- as.integer(maxItemRemovals)

  if (
    !is.numeric(pThreshold) ||
      length(pThreshold) != 1L ||
      is.na(pThreshold) ||
      pThreshold <= 0 ||
      pThreshold > 1
  ) {
    stop("surveyFA requires pThreshold to be in (0, 1].", call. = FALSE)
  }

  response_data <- as.data.frame(data)
  response_data <-
    response_data[, vapply(response_data, function(column) {
      nunique <- length(unique(stats::na.omit(column)))
      nunique >= 2L
    }, logical(1L))]

  if (nrow(response_data) == 0L || ncol(response_data) < 2L) {
    stop("surveyFA needs at least two non-constant response columns.", call. = FALSE)
  }

  has_finite_covariance <- function(model) {
    covariance <- tryCatch(
      {
        direct <- model@vcov
        if (is.null(direct) || length(direct) == 0L) {
          stats::vcov(model)
        } else {
          direct
        }
      },
      error = function(e) {
        tryCatch(stats::vcov(model), error = function(err) NA)
      }
    )

    covariance <- suppressWarnings(as.matrix(covariance))
    is.numeric(covariance) &&
      length(covariance) > 0L &&
      all(dim(covariance) > 0L) &&
      all(is.finite(covariance))
  }

  is_acceptable_model <- function(model) {
    if (!inherits(model, "SingleGroupClass")) {
      return(FALSE)
    }

    converged <- tryCatch(model@OptimInfo$converged, error = function(e) FALSE)
    if (!isTRUE(converged)) {
      return(FALSE)
    }

    log_likelihood <- tryCatch(
      model@Fit$logLik[1],
      error = function(e) NA_real_
    )
    if (!is.finite(log_likelihood)) {
      return(FALSE)
    }

    second_order <- tryCatch(
      model@OptimInfo$secondordertest,
      error = function(e) NA
    )
    if (is.logical(second_order) && isFALSE(second_order)) {
      return(FALSE)
    }
    if (SE && !identical(second_order, TRUE)) {
      return(FALSE)
    }
    if (SE && !has_finite_covariance(model)) {
      return(FALSE)
    }

    TRUE
  }

  try_fit <- function(response_data, method_name) {
    fit_args <- list(
      data = response_data,
      model = 1,
      itemtype = itemtype,
      SE = SE,
      GenRandomPars = FALSE
    )

    if (method_name == "EM") {
      fit_args$method <- "EM"
      fit_args$technical <- list(NCYCLES = 1e5)
      fit_args$empiricalhist <- TRUE
    } else if (method_name == "QMCEM") {
      fit_args$method <- "QMCEM"
      fit_args$technical <- list(NCYCLES = 1e5)
    } else if (method_name == "MHRM") {
      fit_args$method <- "MHRM"
      fit_args$technical <- list(NCYCLES = 1e5, MHRM_SE_draws = 200000)
    } else {
      return(NA)
    }

    if (method_name == "MHRM") {
      fit <- NA
      for (attempt in seq_len(3L)) {
        fit <- tryCatch(
          do.call(mirt::mirt, fit_args),
          error = function(err) {
            warning(
              "fallback surveyFA mirt MHRM attempt #",
              attempt,
              " failed: ",
              err$message,
              call. = FALSE
            )
            NA
          }
        )
        if (inherits(fit, "SingleGroupClass")) {
          break
        }
      }
      fit
    } else {
      tryCatch(
        do.call(mirt::mirt, fit_args),
        error = function(err) {
          warning(err$message, call. = FALSE)
          NA
        }
      )
    }
  }

  select_bad_item <- function(fitted_model, response_data) {
    fit_df <- tryCatch(
      suppressWarnings(mirt::itemfit(fitted_model, fit_stats = "S_X2")),
      error = function(e) NA,
      warning = function(w) {
        tryCatch(
          mirt::itemfit(fitted_model, fit_stats = "PV_Q1*"),
          error = function(err) NA
        )
      }
    )

    p_col_candidates <- c("p", "p.value", "pval", "P")
    if (!is.data.frame(fit_df)) {
      return(NA_character_)
    }

    active <- intersect(names(response_data), rownames(fit_df))
    if (length(active) == 0L) {
      return(NA_character_)
    }

    fit_df <- fit_df[active, , drop = FALSE]
    p_col <- intersect(p_col_candidates, colnames(fit_df))
    if (length(p_col) > 0L) {
      p_values <- suppressWarnings(as.numeric(fit_df[[p_col[1L]]]))
      names(p_values) <- rownames(fit_df)
      if (any(!is.na(p_values))) {
        p_values[is.na(p_values)] <- 1
        candidate <- names(p_values)[which.min(p_values)]
        if (!is.na(candidate) && p_values[[candidate]] < pThreshold) {
          return(candidate)
        }
      }
    }

    v <- vapply(
      response_data[active],
      function(x) stats::var(as.numeric(x), na.rm = TRUE),
      numeric(1L)
    )
    names(v) <- active
    v[!is.finite(v)] <- -Inf
    candidate <- names(which.min(v))
    if (length(candidate) == 0L) NA_character_ else candidate
  }

  removed <- character()
  methods <- c("QMCEM", "EM", "MHRM")
  if (forceNormalEM) {
    methods <- c("EM", "QMCEM", "MHRM")
  } else if (forceMHRM) {
    methods <- c("MHRM", "QMCEM", "EM")
  } else if (unstable) {
    methods <- c("QMCEM", "MHRM", "EM")
  }

  for (removal_round in seq_len(maxItemRemovals + 1L)) {
    fitted <- NA
    for (method_name in methods) {
      fitted <- try_fit(response_data, method_name)
      if (is_acceptable_model(fitted)) {
        return(fitted)
      }
    }

    if (!autofix || ncol(response_data) <= 2L || removal_round > maxItemRemovals) {
      break
    }

    bad_item <- select_bad_item(fitted, response_data)
    if (identical(bad_item, NA_character_) || bad_item %in% removed) {
      break
    }

    response_data <- response_data[, names(response_data) != bad_item, drop = FALSE]
    removed <- c(removed, bad_item)
  }

  stop(
    "surveyFA fallback could not estimate a valid model after bounded recovery attempts. ",
    "Removed items: ",
    if (length(removed) == 0L) "none" else paste(removed, collapse = ", "),
    call. = FALSE
  )
}
