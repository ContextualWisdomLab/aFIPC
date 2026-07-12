#' automated fixed item parameter linking
#'
#' @import mirt

#' @param newformXData new form data X
#' @param oldformYData old form (base form) data Y
#' @param newformCommonItemNames Common item variable names in new form data
#' @param oldformCommonItemNames Common item variable names in old (base) form data
#' @param itemtype itemtype of calibration
#' @param newformBILOGprior using BILOG-MG prior when try to calibrate 3PL model? if you want, set the this to TRUE
#' @param oldformBILOGprior using BILOG-MG prior when try to calibrate 3PL model? if you want, set the this to TRUE
#' @param tryFitwholeNewItems do you want to try calibrate new form data? default is TRUE
#' @param tryFitwholeOldItems do you want to try calibrate base form data? default is TRUE
#' @param checkIPD do you want to check item parameter drift? default is TRUE
#' @param tryEM do you want to try EM algorithm when you calibrate model? defalut is TRUE
#' @param freeMEAN allow freely mean estimation, default is TRUE
#' @param forceNormalZeroOne set the prior distribution follows N(0,1) distribution. default is FALSE
#' @param parameterOverwrite don't touch it
#' @param empiricalhist do you want to use empirical histogram method when tryEM = TRUE? default is FALSE
#' @param confirmCommonItems set TRUE to accept the supplied common-item pairs without an interactive prompt. Default NULL: in interactive sessions the user will be prompted; set FALSE to explicitly reject (function will stop).
#' @param ... Additional arguments reserved for future extensions.
#'
#' @return the model list of the base form, new form, linked form
#' @export
#'
#' @examples
#' \dontrun{
#' autoFIPC(
#'   newformXData = new_model,
#'   oldformYData = old_model,
#'   newformCommonItemNames = common_new,
#'   oldformCommonItemNames = common_old,
#'   confirmCommonItems = TRUE
#' )
#' }
autoFIPC <-
  function(
    newformXData,
    oldformYData,
    newformCommonItemNames,
    oldformCommonItemNames,
    itemtype = '3PL',
    newformBILOGprior = NULL,
    oldformBILOGprior = NULL,
    tryFitwholeNewItems = T,
    tryFitwholeOldItems = T,
    checkIPD = T,
    tryEM = T,
    freeMEAN = T,
    forceNormalZeroOne = F,
    parameterOverwrite = F,
    empiricalhist = F,
    confirmCommonItems = NULL,
    ...
  ) {
    # print credits
    message('automated Fixed Item Parameter Calibration: aFIPC 0.2')
    message('Seongho Bae (seongho@kw.ac.kr)\n')
    try(invisible(gc()), silent = T)
    # garbage cleaning

    # Input validation - Security Enhancement
    isRealMirtModel <- function(x) {
      if (!isS4(x) || !methods::is(x, "SingleGroupClass")) return(FALSE)
      ok <- tryCatch({
        vals <- mirt::mod2values(x)
        is.data.frame(vals) || is.matrix(vals)
      }, error = function(e) FALSE, warning = function(w) FALSE)
      if (!isTRUE(ok)) return(FALSE)
      required_slots <- c("OptimInfo", "ParObjects")
      return(all(required_slots %in% methods::slotNames(x)))
    }
    if (!is.data.frame(newformXData) && !is.matrix(newformXData) && !isRealMirtModel(newformXData)) {
      stop("Security Error: newformXData must be a data.frame, matrix, or a valid fitted mirt model")
    }
    if (!is.data.frame(oldformYData) && !is.matrix(oldformYData) && !isRealMirtModel(oldformYData)) {
      stop("Security Error: oldformYData must be a data.frame, matrix, or a valid fitted mirt model")
    }

    if (!is.character(newformCommonItemNames) && !is.factor(newformCommonItemNames)) {
      stop("Security Error: newformCommonItemNames must be a character vector")
    }
    if (!is.character(oldformCommonItemNames) && !is.factor(oldformCommonItemNames)) {
      stop("Security Error: oldformCommonItemNames must be a character vector")
    }

    if (!is.character(itemtype)) stop('Security Error: itemtype must be a character vector')
    nItems <- NA_integer_
    if (is.data.frame(newformXData) || is.matrix(newformXData)) nItems <- ncol(as.data.frame(newformXData))
    else if (is.data.frame(oldformYData) || is.matrix(oldformYData)) nItems <- ncol(as.data.frame(oldformYData))
    if (!is.na(nItems) && !(length(itemtype) == 1 || length(itemtype) == nItems)) stop(sprintf('Security Error: itemtype must be length 1 or length %d (number of items).', nItems))

    # boolean parameter validation
    if (!is.null(newformBILOGprior) && (!is.logical(newformBILOGprior) || length(newformBILOGprior) != 1 || is.na(newformBILOGprior))) stop("Security Error: newformBILOGprior must be a single non-NA logical value or NULL")
    if (!is.null(oldformBILOGprior) && (!is.logical(oldformBILOGprior) || length(oldformBILOGprior) != 1 || is.na(oldformBILOGprior))) stop("Security Error: oldformBILOGprior must be a single non-NA logical value or NULL")
    if (!is.null(confirmCommonItems) && (!is.logical(confirmCommonItems) || length(confirmCommonItems) != 1 || is.na(confirmCommonItems))) stop("Security Error: confirmCommonItems must be a single non-NA logical value or NULL")
    if (!is.logical(tryFitwholeNewItems) || length(tryFitwholeNewItems) != 1 || is.na(tryFitwholeNewItems)) stop("Security Error: tryFitwholeNewItems must be a single non-NA logical value")
    if (!is.logical(tryFitwholeOldItems) || length(tryFitwholeOldItems) != 1 || is.na(tryFitwholeOldItems)) stop("Security Error: tryFitwholeOldItems must be a single non-NA logical value")
    if (!is.logical(checkIPD) || length(checkIPD) != 1 || is.na(checkIPD)) stop("Security Error: checkIPD must be a single non-NA logical value")
    if (!is.logical(tryEM) || length(tryEM) != 1 || is.na(tryEM)) stop("Security Error: tryEM must be a single non-NA logical value")
    if (!is.logical(freeMEAN) || length(freeMEAN) != 1 || is.na(freeMEAN)) stop("Security Error: freeMEAN must be a single non-NA logical value")
    if (!is.logical(forceNormalZeroOne) || length(forceNormalZeroOne) != 1 || is.na(forceNormalZeroOne)) stop("Security Error: forceNormalZeroOne must be a single non-NA logical value")
    if (!is.logical(parameterOverwrite) || length(parameterOverwrite) != 1 || is.na(parameterOverwrite)) stop("Security Error: parameterOverwrite must be a single non-NA logical value")
    if (!is.logical(empiricalhist) || length(empiricalhist) != 1 || is.na(empiricalhist)) stop("Security Error: empiricalhist must be a single non-NA logical value")

    # checking configure
    if (length(newformCommonItemNames) != length(oldformCommonItemNames)) {
      stop('Common Items are not equal')
    }

    if (
      length(newformCommonItemNames) == 0 |
        length(oldformCommonItemNames) == 0
    ) {
      stop('Please provide common item names')
    }

    # checking common items
    message('Checking correspond common item names')
    to <- rep("<<<", length(newformCommonItemNames))
    print(data.frame(cbind(
      newformCommonItemNames,
      to,
      oldformCommonItemNames
    )))
    correspondItems <-
      data.frame(cbind(newformCommonItemNames, oldformCommonItemNames))

    checkCorrect <- function() {
      if (isTRUE(confirmCommonItems)) {
        return(1L)
      }
      if (identical(confirmCommonItems, FALSE)) {
        return(2L)
      }
      if (!interactive()) {
        stop(
          'Common item confirmation requires an interactive session; ',
          'set confirmCommonItems = TRUE to accept the supplied pairs.'
        )
      }
      for (attempt in seq_len(3)) {
        n <- readline(prompt = "Is it correct? (1: Yes 2: No) : ")
        if (grepl("^[0-9]+$", n)) {
          return(as.integer(n))
        }
      }
      stop("Too many invalid common item confirmation attempts")
    }
    confirm <- checkCorrect()
    if (confirm != 1) {
      stop('Please write down pairs correctly')
    }

    # estimate models for calibration
    if (
      !is.data.frame(oldformYData) &&
        !is.matrix(oldformYData)
    ) {
      # if Data is mirt model
      oldFormModel <- oldformYData
      oldformYDataK <- data.frame(oldFormModel@Data$data)
    } else {
      # if Data is data.frame
      oldformYDataK <- oldformYData
      if (itemtype == '3PL' && length(oldformBILOGprior) == 0) {
        checkoldformBILOGprior <- function() {
          if (!interactive()) stop("Interactive session required for oldform BILOG prior")
          for (attempt in seq_len(3)) {
            n <-
              readline(
                prompt = "Do you want to use default BILOG-MG priors for oldform Data? (1: Yes 2: No) : "
              )
            if (grepl("^[0-9]+$", n)) {
              return(as.integer(n))
            }
          }
          stop("Too many invalid oldform BILOG prior attempts")
        }
        oldformBILOGprior <- checkoldformBILOGprior()
        if (oldformBILOGprior == 1) {
          oldformBILOGprior <- TRUE
        } else {
          oldformBILOGprior <- FALSE
        }
      }

      message('\nestimating oldForm (Y) parameters')
      if (itemtype == '3PL' && oldformBILOGprior == T) {
        message('with traditional MMLE/EM approach')
        oldFormModelSyntax <-
          mirt::mirt.model(
            paste0(
              'F1 = 1-',
              ncol(oldformYData),
              '\n',
              'PRIOR = (1-',
              ncol(oldformYData),
              ', a1, lnorm, 1, 1.6487), ',
              '(1-',
              ncol(oldformYData),
              ', g, norm, .22, .08)'
            )
          )
        try(
          oldFormModel <-
            mirt::mirt(
              data = oldformYData,
              model = oldFormModelSyntax,
              itemtype = itemtype,
              SE = T,
              accelerate = 'squarem'
            )
        )
      } else {
        # try to search priors automatically. if it fail, try to bayesian approaches
        message(
          'with estimate prior distribution using an empirical histogram approach. please be patient.'
        )
        try(
          oldFormModel <-
            mirt::mirt(
              data = oldformYData,
              model = 1,
              itemtype = itemtype,
              SE = T,
              accelerate = 'squarem',
              empiricalhist = T,
              technical = list(NCYCLES = 1e+5),
              GenRandomPars = F
            )
        )
      }

      if (!exists("oldFormModel", inherits = FALSE)) {
        stop("Security Error: Initial estimation of oldFormModel completely failed")
      }

      if (tryFitwholeOldItems == T) {
        if (
          (!exists("oldFormModel", inherits = FALSE)) || (!isTRUE(oldFormModel@OptimInfo$secondordertest) &&
            itemtype != 'ideal')
        ) {
          message(
            'Estimation failed. estimating new parameters with no prior distribution using quasi-Monte Carlo EM estimation. please be patient.'
          )

          try(rm(oldFormModel))
          try(
            oldFormModel <-
              mirt::mirt(
                data = oldformYDataK,
                1,
                itemtype = itemtype,
                SE = T,
                method = 'QMCEM',
                accelerate = 'squarem',
                technical = list(NCYCLES = 1e+5),
                GenRandomPars = F
              )
          )
        }

        if (
          (!exists("oldFormModel", inherits = FALSE)) || (!isTRUE(oldFormModel@OptimInfo$secondordertest) &&
            itemtype != 'ideal')
        ) {
          message(
            'Estimation failed. estimating new parameters with no prior distribution using  Cai\'s (2010) Metropolis-Hastings Robbins-Monro (MHRM) algorithm. please be patient.'
          )

          try(rm(oldFormModel), silent = TRUE)
          for (attempt in seq_len(3)) {
            try(
              oldFormModel <-
                mirt::mirt(
                  data = oldformYDataK,
                  1,
                  itemtype = itemtype,
                  SE = T,
                  method = 'MHRM',
                  accelerate = 'squarem',
                  technical = list(NCYCLES = 1e+5, MHRM_SE_draws = 200000),
                  GenRandomPars = F
                )
            )
            if (exists('oldFormModel', inherits = FALSE)) break
          }
          if (!exists('oldFormModel', inherits = FALSE)) stop('Failed to estimate oldFormModel with MHRM after 3 attempts')
        }
      }

      if (
        (!exists("oldFormModel", inherits = FALSE)) || (!isTRUE(oldFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        message(
          'Estimation failed. trying to remove weird items by itemfit statistics'
        )
        try(rm(oldFormModel))

        oldFormModel <-
          surveyFA(
            oldformYData,
            autofix = F,
            SE = T,
            forceUIRT = T
          )
      }

      if (
        (!exists("oldFormModel", inherits = FALSE)) || (!isTRUE(oldFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        message(
          'Estimation failed. trying to remove weird items by itemfit statistics by normal MMLE/EM'
        )
        try(rm(oldFormModel))

        oldFormModel <-
          surveyFA(
            oldformYData,
            autofix = F,
            SE = T,
            forceUIRT = T,
            forceNormalEM = T
          )
      }

      if (
        (!exists("oldFormModel", inherits = FALSE)) || (!isTRUE(oldFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        message(
          'Estimation failed. trying to remove weird items by itemfit statistics by MMLE/QMCEM'
        )
        try(rm(oldFormModel))

        oldFormModel <-
          surveyFA(
            oldformYData,
            autofix = F,
            SE = T,
            forceUIRT = T,
            unstable = T
          )
      }

      if (
        (!exists("oldFormModel", inherits = FALSE)) || (!isTRUE(oldFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        message(
          'Estimation failed. trying to remove weird items by itemfit statistics by MMLE/MHRM'
        )
        try(rm(oldFormModel))

        oldFormModel <-
          surveyFA(
            oldformYData,
            autofix = F,
            SE = T,
            forceUIRT = T,
            forceMHRM = T
          )
      }

      if (
        (!exists("oldFormModel", inherits = FALSE)) || (!isTRUE(oldFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        stop('Estimation failed. Please check test quality.')
      }
    }

    if (
      !is.data.frame(newformXData) &&
        !is.matrix(newformXData)
    ) {
      # if Data is mirt model
      newFormModel <- newformXData
      newformXDataK <- data.frame(newFormModel@Data$data)
    } else {
      newformXDataK <- newformXData
      if (itemtype == '3PL' && length(newformBILOGprior) == 0) {
        checknewformBILOGprior <- function() {
          if (!interactive()) stop("Interactive session required for newform BILOG prior")
          for (attempt in seq_len(3)) {
            n <-
              readline(
                prompt = "Do you want to use default BILOG-MG priors for newform Data? (1: Yes 2: No) : "
              )
            if (grepl("^[0-9]+$", n)) {
              return(as.integer(n))
            }
          }
          stop("Too many invalid newform BILOG prior attempts")
        }
        newformBILOGprior <- checknewformBILOGprior()
        if (newformBILOGprior == 1) {
          newformBILOGprior <- TRUE
        } else {
          newformBILOGprior <- FALSE
        }
      }

      message('\nestimating newForm (X) parameters')
      if (itemtype == '3PL' && newformBILOGprior == T) {
        message('with traditional MMLE/EM approach')
        newFormModelSyntax <-
          mirt::mirt.model(
            paste0(
              'F1 = 1-',
              ncol(newformXData),
              '\n',
              'PRIOR = (1-',
              ncol(newformXData),
              ', a1, lnorm, 1, 1.6487), ',
              '(1-',
              ncol(newformXData),
              ', g, norm, .22, .08)'
            )
          )
        try(
          newFormModel <-
            mirt::mirt(
              data = newformXData,
              model = newFormModelSyntax,
              itemtype = itemtype,
              SE = T,
              accelerate = 'squarem'
            )
        )
      } else {
        message(
          'with estimate prior distribution using an empirical histogram approach. please be patient.'
        )
        try(
          newFormModel <-
            mirt::mirt(
              data = newformXDataK,
              1,
              itemtype = itemtype,
              SE = T,
              empiricalhist = T,
              accelerate = 'squarem',
              technical = list(NCYCLES = 1e+5),
              GenRandomPars = F
            )
        )
      }

      if (!exists("newFormModel", inherits = FALSE)) {
        stop("Security Error: Initial estimation of newFormModel completely failed")
      }

      if (tryFitwholeNewItems) {
        if (
          (!exists("newFormModel", inherits = FALSE)) || (!isTRUE(newFormModel@OptimInfo$secondordertest) &&
            itemtype != 'ideal')
        ) {
          message(
            'Estimation failed. estimating new parameters with no prior distribution using quasi-Monte Carlo EM estimation. please be patient.'
          )

          try(rm(newFormModel))
          try(
            newFormModel <-
              mirt::mirt(
                data = newformXDataK,
                1,
                itemtype = itemtype,
                SE = T,
                method = 'QMCEM',
                accelerate = 'squarem',
                technical = list(NCYCLES = 1e+5),
                GenRandomPars = F
              )
          )
        }

        if (
          (!exists("newFormModel", inherits = FALSE)) || (!isTRUE(newFormModel@OptimInfo$secondordertest) &&
            itemtype != 'ideal')
        ) {
          message(
            'Estimation failed. estimating new parameters with no prior distribution using  Cai\'s (2010) Metropolis-Hastings Robbins-Monro (MHRM) algorithm. please be patient.'
          )

          try(rm(newFormModel), silent = TRUE)
          for (attempt in seq_len(3)) {
            try(
              newFormModel <-
                mirt::mirt(
                  data = newformXDataK,
                  1,
                  itemtype = itemtype,
                  SE = T,
                  method = 'MHRM',
                  accelerate = 'squarem',
                  technical = list(NCYCLES = 1e+5, MHRM_SE_draws = 200000),
                  GenRandomPars = F
                )
            )
            if (exists('newFormModel', inherits = FALSE)) break
          }
          if (!exists('newFormModel', inherits = FALSE)) stop('Failed to estimate newFormModel with MHRM after 3 attempts')
        }
      }

      if (
        (!exists("newFormModel", inherits = FALSE)) || (!isTRUE(newFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        message(
          'Estimation failed. trying to remove weird items by itemfit statistics'
        )
        try(rm(newFormModel))

        newFormModel <-
          surveyFA(
            newformXData,
            autofix = F,
            SE = T,
            forceUIRT = T
          )
      }

      if (
        (!exists("newFormModel", inherits = FALSE)) || (!isTRUE(newFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        message(
          'Estimation failed. trying to remove weird items by itemfit statistics again by normal MMLE/EM'
        )
        try(rm(newFormModel))

        newFormModel <-
          surveyFA(
            newformXData,
            autofix = F,
            SE = T,
            forceUIRT = T,
            forceNormalEM = T
          )
      }

      if (
        (!exists("newFormModel", inherits = FALSE)) || (!isTRUE(newFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        message(
          'Estimation failed. trying to remove weird items by itemfit statistics again by MMLE/QMCEM'
        )
        try(rm(newFormModel))

        newFormModel <-
          surveyFA(
            newformXData,
            autofix = F,
            SE = T,
            forceUIRT = T,
            unstable = T
          )
      }

      if (
        (!exists("newFormModel", inherits = FALSE)) || (!isTRUE(newFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        message(
          'Estimation failed. trying to remove weird items by itemfit statistics again by MMLE/MHRM'
        )
        try(rm(newFormModel))

        newFormModel <-
          surveyFA(
            newformXData,
            autofix = F,
            SE = T,
            forceUIRT = T,
            forceMHRM = T
          )
      }

      if (
        (!exists("newFormModel", inherits = FALSE)) || (!isTRUE(newFormModel@OptimInfo$secondordertest) &&
          itemtype != 'ideal')
      ) {
        stop('Estimation failed. Please check test quality.')
      }
    }

    # do FIPC
    NewScaleParms <- mirt::mod2values(newFormModel)
    OldScaleParms <- mirt::mod2values(oldFormModel)

    # Preserve mirt's structural estimability flags. Forcing every row TRUE
    # frees boundary parameters such as 2PL g/u and makes the Hessian unstable.

    NewScaleParms[which(NewScaleParms$item == paste0('GROUP')), "est"] <-
      FALSE
    OldScaleParms[which(OldScaleParms$item == paste0('GROUP')), "est"] <-
      FALSE

    NewScaleParms[which(NewScaleParms$name == "COV_11"), "est"] <-
      TRUE
    OldScaleParms[which(OldScaleParms$name == "COV_11"), "est"] <-
      TRUE

    if (itemtype == 'Rasch') {
      NewScaleParms[which(NewScaleParms$name == "a1"), "est"] <- FALSE
      OldScaleParms[which(OldScaleParms$name == "a1"), "est"] <- FALSE
    }

    #IPD
    if (checkIPD == T) {
      # config
      IPDgroup <-
        as.factor(c(
          rep('oldForm', nrow(oldformYDataK)),
          rep('newForm', nrow(newformXDataK))
        ))
      IPDItemCount <- 0

      # IPD target item checking
      newFormColNames <- colnames(newformXDataK[colnames(newFormModel@Data$data)])
      oldFormColNames <- colnames(oldformYDataK[colnames(oldFormModel@Data$data)])

      # ⚡ Bolt: Vectorized match() to avoid dynamic array growth overhead inside a for loop
      idxNew <- match(newformCommonItemNames, newFormColNames)
      idxOld <- match(oldformCommonItemNames, oldFormColNames)
      valid_idx <- !is.na(idxNew) & !is.na(idxOld)

      IPDItemNamesNewForm <- newFormColNames[idxNew[valid_idx]]
      IPDItemNamesOldForm <- oldFormColNames[idxOld[valid_idx]]
      IPDItemCount <- length(IPDItemNamesNewForm)

      # IPD Data generation
      IPDItemList <-
        data.frame(rbind(IPDItemNamesOldForm, IPDItemNamesNewForm))

      IPDData <-
        data.frame(matrix(nrow = length(IPDgroup), ncol = IPDItemCount))
      colnames(IPDData) <- paste0('X', 1:IPDItemCount)
      print(IPDItemNamesOldForm)
      print(IPDItemNamesNewForm)
      IPDData[1:nrow(oldformYDataK), ] <-
        oldformYDataK[, IPDItemNamesOldForm]
      IPDData[nrow(oldformYDataK) + 1:nrow(newformXDataK), ] <-
        newformXDataK[, IPDItemNamesNewForm]

      # IPD estimation
      IPDParmNames <- OldScaleParms$name
      IPDParmNames <- IPDParmNames[!duplicated(IPDParmNames)]
      IPDParmNames <- IPDParmNames[!grepl("^(MEAN|COV|ak|d0$)", IPDParmNames)]
      IPDParmNames <- as.character(IPDParmNames)

      mirt::mirtCluster()
      message('Discovering IPD')
      if (itemtype == 'nominal' | tryEM == T) {
        if (empiricalhist == T) {
          modIPD_MG <- mirt::multipleGroup(
            IPDData,
            model = 1,
            group = IPDgroup,
            itemtype = itemtype,
            method = 'EM',
            invariance = c(names(IPDData), 'free_means', 'free_var'),
            empiricalhist = T,
            technical = list(NCYCLES = 1e+5, removeEmptyRows = TRUE)
          )
          try(
            modIPD_DIF <-
              mirt::DIF(
                modIPD_MG,
                IPDParmNames,
                scheme = 'drop_sequential',
                method = 'EM',
                empiricalhist = T,
                technical = list(NCYCLES = 1e+5)
              )
          )
        } else {
          modIPD_MG <- mirt::multipleGroup(
            IPDData,
            model = 1,
            group = IPDgroup,
            itemtype = itemtype,
            method = 'EM',
            invariance = c(names(IPDData), 'free_means', 'free_var'),
            empiricalhist = F,
            technical = list(NCYCLES = 1e+5, removeEmptyRows = TRUE)
          )
          try(
            modIPD_DIF <-
              mirt::DIF(
                modIPD_MG,
                IPDParmNames,
                scheme = 'drop_sequential',
                method = 'EM',
                empiricalhist = F,
                technical = list(NCYCLES = 1e+5)
              )
          )
        }
      } else {
        modIPD_MG <- mirt::multipleGroup(
          IPDData,
          model = 1,
          group = IPDgroup,
          itemtype = itemtype,
          method = 'MHRM',
          invariance = c(names(IPDData), 'free_means', 'free_var'),
          technical = list(NCYCLES = 1e+5, removeEmptyRows = TRUE)
        )
        try(
          modIPD_DIF <-
            mirt::DIF(
              modIPD_MG,
              IPDParmNames,
              scheme = 'drop_sequential',
              method = 'MHRM',
              technical = list(NCYCLES = 1e+5)
            )
        )
      }
      mirt::mirtCluster(remove = T)

      if (exists('modIPD_DIF', inherits = FALSE)) {
        modIPD_IPDItem <- names(modIPD_DIF)
        CommonItemList_NOIPD <-
          colnames(IPDData)[!colnames(IPDData) %in% modIPD_IPDItem]
        print(modIPD_DIF)
        print(CommonItemList_NOIPD)

        # ⚡ Bolt: 루프 내에서 데이터 프레임을 서브셋팅(subsetting)하는 O(N) 연산을
        # unlist()를 활용한 벡터화된(vectorized) O(1) 연산으로 대체하여 성능 향상
        ActualoldFormCommonItem <-
          as.character(unlist(IPDItemList[1, CommonItemList_NOIPD]))
        ActualnewFormCommonItem <-
          as.character(unlist(IPDItemList[2, CommonItemList_NOIPD]))

        message('ActualoldFormCommonItem: ', ActualoldFormCommonItem)
        message('ActualnewFormCommonItem: ', ActualnewFormCommonItem)

        oldformCommonItemNames <- ActualoldFormCommonItem
        newformCommonItemNames <- ActualnewFormCommonItem
        message('oldformCommonItemNames: ', ActualoldFormCommonItem)
        message('newformCommonItemNames: ', ActualnewFormCommonItem)
      } else {
        message('No IPD detected')
      }
    }

    newFormColNames <- colnames(newformXDataK[colnames(newFormModel@Data$data)])
    oldFormColNames <- colnames(oldformYDataK[colnames(oldFormModel@Data$data)])

    # ⚡ Bolt: Cache parameter indices to avoid O(N) linear search inside loop
    newScaleParmsItemIdxCache <- split(seq_len(nrow(NewScaleParms)), NewScaleParms$item)
    oldScaleParmsItemIdxCache <- split(seq_len(nrow(OldScaleParms)), OldScaleParms$item)

    # ⚡ Bolt: Vectorize match() outside the loop to avoid repeated array scanning overhead
    idxNew_all <- match(newformCommonItemNames, newFormColNames)
    idxOld_all <- match(oldformCommonItemNames, oldFormColNames)

    for (i in seq_along(oldformCommonItemNames)) {
      newFormItemStr <- newformCommonItemNames[i]
      oldFormItemStr <- oldformCommonItemNames[i]

      newFormItemName <- newFormColNames[idxNew_all[i]]
      oldFormItemName <- oldFormColNames[idxOld_all[i]]

      if (
        !is.na(newFormItemName) &&
        !is.na(oldFormItemName) &&
          (length(stats::na.omit(unique(newFormModel@Data$data[, newFormItemName]))) ==
            length(stats::na.omit(unique(oldFormModel@Data$data[, oldFormItemName]))))
      ) {
        message(
          'applying ',
          newFormItemStr,
          ' <<< ',
          oldFormItemStr,
          ' as common item use'
        )

        # ⚡ Bolt: Use cached O(1) dictionary lookups instead of O(N) which() scans
        newIdx <- newScaleParmsItemIdxCache[[newFormItemStr]]
        oldIdx <- oldScaleParmsItemIdxCache[[oldFormItemStr]]

        # ⚡ Bolt: Remove unnecessary paste0() array string generation overhead
        message('   Newform Parms: ', paste(NewScaleParms[newIdx, "value"], collapse = ' '))
        message('   Oldform Parms: ', paste(OldScaleParms[oldIdx, "value"], collapse = ' '))

        NewScaleParms[newIdx, "value"] <-
          OldScaleParms[oldIdx, "value"]
        message('   Linkedform Parms: ', paste(NewScaleParms[newIdx, "value"], collapse = ' '), '\n')

        NewScaleParms[newIdx, "est"] <-
          FALSE
      } else {
        message(
          'skipping ',
          newFormItemStr,
          ' <<< ',
          oldFormItemStr,
          ' as common item use'
        )
      }
    }

    if (
      length(attr(newFormModel@ParObjects$lrPars, 'parnum')) != 0 &&
        length(attr(oldFormModel@ParObjects$lrPars, 'parnum')) != 0
    ) {
      newBetaIdx <- which(NewScaleParms$item == 'BETA')
      oldBetaIdx <- which(OldScaleParms$item == 'BETA')

      NewScaleParms[newBetaIdx, "value"] <-
        OldScaleParms[oldBetaIdx, "value"]
      NewScaleParms[newBetaIdx, "est"] <-
        FALSE

      message('applying BETA parameter as linking')

      message(
        '   Linkedform Parms: ',
        paste0(
          NewScaleParms[newBetaIdx, "value"],
          ' '
        ),
        '\n'
      )
      betaFormula <-
        attr(newFormModel@ParObjects$lrPars, 'formula')[[1]]
      betaCOVdata <- attr(newFormModel@ParObjects$lrPars, 'df')
      betaSE <- FALSE
      betaEmpiricalhist <- FALSE
    } else if (empiricalhist == F) {
      betaFormula <- NULL
      betaCOVdata <- NULL
      betaSE <- TRUE
      betaEmpiricalhist <- FALSE
    } else {
      betaFormula <- NULL
      betaCOVdata <- NULL
      betaSE <- TRUE
      betaEmpiricalhist <- TRUE
    }

    message('\nestimating Linked Form Eq(X) parameters')
    if (forceNormalZeroOne) {
      freeMEAN <- F

      NewScaleParms[which(NewScaleParms$name == "COV_11"), "est"] <-
        FALSE
      OldScaleParms[which(OldScaleParms$name == "COV_11"), "est"] <-
        FALSE
      NewScaleParms[which(NewScaleParms$name == "MEAN_11"), "est"] <-
        FALSE
      OldScaleParms[which(OldScaleParms$name == "MEAN_11"), "est"] <-
        FALSE
      NewScaleParms[which(NewScaleParms$name == "COV_11"), "value"] <-
        1
      OldScaleParms[which(OldScaleParms$name == "MEAN_11"), "value"] <-
        0
    }
    if (freeMEAN == T) {
      LinkedModelSyntax <-
        mirt::mirt.model(paste0(
          'F1 = 1-',
          ncol(newformXDataK[colnames(newFormModel@Data$data)]),
          '\n',
          'MEAN = F1'
        ))

      NewScaleParms[which(NewScaleParms$name == "MEAN_1"), "est"] <-
        TRUE
      OldScaleParms[which(OldScaleParms$name == "MEAN_1"), "est"] <-
        TRUE
    } else {
      LinkedModelSyntax <-
        mirt::mirt.model(paste0(
          'F1 = 1-',
          ncol(newformXDataK[colnames(newFormModel@Data$data)]),
          '\n'
        ))
    }

    print(NewScaleParms)

    if (itemtype == 'nominal' | tryEM == T) {
      if (betaEmpiricalhist) {
        message(
          'with MMLE/EM + empirical histogram approach. please be patient.'
        )
      } else {
        message('with MMLE/EM approach. please be patient.')
      }
      if (sum(NewScaleParms$est) == 0) {
        # LinkedModel <- oldFormModel

        LinkedModel <-
          mirt::mirt(
            data = newformXDataK[colnames(newFormModel@Data$data)],
            LinkedModelSyntax,
            itemtype = newFormModel@Model$itemtype,
            method = 'EM',
            SE = F,
            accelerate = 'squarem',
            empiricalhist = betaEmpiricalhist,
            technical = list(
              NCYCLES = 1e+6,
              SEtol = 1e-4,
              MHRM_SE_draws = 1e+5
            ),
            pars = NewScaleParms,
            GenRandomPars = F,
            covdata = betaCOVdata,
            formula = betaFormula
          )
      } else {
        LinkedModel <-
          mirt::mirt(
            data = newformXDataK[colnames(newFormModel@Data$data)],
            LinkedModelSyntax,
            itemtype = newFormModel@Model$itemtype,
            method = 'EM',
            SE = betaSE,
            accelerate = 'squarem',
            empiricalhist = betaEmpiricalhist,
            technical = list(
              NCYCLES = 1e+6,
              SEtol = 1e-4,
              MHRM_SE_draws = 1e+5
            ),
            pars = NewScaleParms,
            GenRandomPars = F,
            covdata = betaCOVdata,
            formula = betaFormula
          )
      }
    } else {
      message(
        'with Cai\'s (2010) Metropolis-Hastings Robbins-Monro (MHRM) approach. please be patient.'
      )

      if (sum(NewScaleParms$est) == 0) {
        # LinkedModel <- oldFormModel
        LinkedModel <-
          mirt::mirt(
            data = newformXDataK[colnames(newFormModel@Data$data)],
            LinkedModelSyntax,
            itemtype = newFormModel@Model$itemtype,
            method = 'MHRM',
            SE = F,
            accelerate = 'squarem',
            TOL = .0005,
            technical = list(
              NCYCLES = 1e+6,
              SEtol = 1e-4,
              MHRM_SE_draws = 1e+5
            ),
            pars = NewScaleParms,
            GenRandomPars = F,
            covdata = betaCOVdata,
            formula = betaFormula
          )
      } else {
        LinkedModel <-
          mirt::mirt(
            data = newformXDataK[colnames(newFormModel@Data$data)],
            LinkedModelSyntax,
            itemtype = newFormModel@Model$itemtype,
            method = 'MHRM',
            SE = betaSE,
            accelerate = 'squarem',
            TOL = .0005,
            technical = list(
              NCYCLES = 1e+6,
              SEtol = 1e-4,
              MHRM_SE_draws = 1e+5
            ),
            pars = NewScaleParms,
            GenRandomPars = F,
            covdata = betaCOVdata,
            formula = betaFormula
          )
      }
    }

    # if(!LinkedModel@OptimInfo$secondordertest){
    #   message('Estimation failed. estimating new parameters with no prior distribution using quasi-Monte Carlo EM estimation. please be patient.')
    #
    #   rm(LinkedModel)
    #   try(LinkedModel <- mirt::mirt(data = newformXDataK[colnames(newFormModel@Data$data)], LinkedModelSyntax, itemtype = newFormModel@Model$itemtype, SE = T, method = 'QMCEM', accelerate = 'squarem', technical = list(NCYCLES = 1e+5), pars = NewScaleParms, GenRandomPars = F))
    # }
    #
    # if(!LinkedModel@OptimInfo$secondordertest){
    #   message('Estimation failed. estimating new parameters with no prior distribution using  Cai\'s (2010) Metropolis-Hastings Robbins-Monro (MHRM) algorithm. please be patient.')
    #
    #   try(rm(LinkedModel), silent = TRUE)
    #   for (attempt in seq_len(3)) {
    #     try(LinkedModel <- mirt::mirt(data = newformXDataK[colnames(newFormModel@Data$data)], LinkedModelSyntax, itemtype = newFormModel@Model$itemtype, SE = T, method = 'MHRM', accelerate = 'squarem', technical = list(NCYCLES = 1e+5, MHRM_SE_draws = 200000), pars = NewScaleParms, GenRandomPars = T))
    #     if (exists('LinkedModel')) break
    #   }
    #   if (!exists('LinkedModel')) stop('Failed to estimate LinkedModel with MHRM after 3 attempts')
    # }

    # if(!LinkedModel@OptimInfo$secondordertest){
    #   stop('Estimation failed. Please check test quality.')
    # }

    # calculate theta
    ThetaOldform <- mirt::fscores(oldFormModel, method = 'MAP')
    ThetaLinkedform <- mirt::fscores(LinkedModel, method = 'MAP')
    ThetaNewform <- mirt::fscores(newFormModel, method = 'MAP')

    # calculate expected score
    ExpectedScoreOldform <-
      mirt::expected.test(
        x = oldFormModel,
        Theta = ThetaOldform
      )
    ExpectedScoreLinkedform <-
      mirt::expected.test(
        x = LinkedModel,
        Theta = ThetaLinkedform
      )
    ExpectedScoreNewform <-
      mirt::expected.test(
        x = newFormModel,
        Theta = ThetaNewform
      )

    # save results as object
    modelReturn <- new.env()
    modelReturn$oldFormModel <- oldFormModel
    modelReturn$newFormModel <- newFormModel
    modelReturn$LinkedModel <- LinkedModel
    modelReturn$ExpectedScoreOldform <- ExpectedScoreOldform
    modelReturn$ExpectedScoreLinkedform <- ExpectedScoreLinkedform
    modelReturn$ExpectedScoreNewform <- ExpectedScoreNewform
    modelReturn$ThetaOldform <- ThetaOldform
    modelReturn$ThetaNewform <- ThetaNewform
    modelReturn$ThetaLinkedform <- ThetaLinkedform
    if (checkIPD) {
      modelReturn$IPDData <- data.frame(IPDData, IPDgroup)
      if (exists('CommonItemList_NOIPD', inherits = FALSE)) {
        modelReturn$IPDCommonItemList <- IPDItemList[CommonItemList_NOIPD]
      }
    }

    return(as.list(modelReturn))
  }
