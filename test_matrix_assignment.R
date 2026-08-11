IPDData <- data.frame(matrix(rnorm(10), 10, 1))
IPDgroup <- factor(rep(c('old', 'new'), c(5,5)), levels=c('old','new'))
IPDData$IPDgroup <- IPDgroup
print(IPDData)
