mat <- matrix(rnorm(10000 * 1000), nrow = 10000, ncol = 1000)

cat("Using as.data.frame:\n")
print(system.time({
  for (i in 1:100) {
    res <- ncol(as.data.frame(mat))
  }
}))

cat("\nDirectly on matrix:\n")
print(system.time({
  for (i in 1:100) {
    res <- ncol(mat)
  }
}))
