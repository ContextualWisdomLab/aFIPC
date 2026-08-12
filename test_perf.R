n1 <- 1000000
n2 <- 1500000

t1 <- system.time({
  for(i in 1:10) {
    as.factor(c(rep('oldForm', n1), rep('newForm', n2)))
  }
})
cat("Original:", t1["elapsed"], "\n")

t2 <- system.time({
  for(i in 1:10) {
    factor(rep(c('oldForm', 'newForm'), c(n1, n2)), levels = c('oldForm', 'newForm'))
  }
})
cat("Optimized:", t2["elapsed"], "\n")
