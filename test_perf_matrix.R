IPDData <- matrix(rnorm(100), 10, 10)
IPDgroup <- factor(rep(c('oldForm', 'newForm'), c(5,5)), levels=c('oldForm', 'newForm'))
modelReturn <- new.env()
tryCatch({
  modelReturn$IPDData <- IPDData
  modelReturn$IPDData$IPDgroup <- IPDgroup
}, error=function(e) print(e))
