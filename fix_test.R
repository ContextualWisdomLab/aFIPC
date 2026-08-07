library(microbenchmark)
df <- as.data.frame(matrix(rnorm(1e7), ncol=100))
colnames(df) <- paste0("C", 1:100)
cols <- paste0("C", sample(1:100, 20))

mb <- microbenchmark(
  subsetting = colnames(df[cols]),
  intersecting = intersect(colnames(df), cols),
  matching = cols[cols %in% colnames(df)],
  times = 1000
)
print(mb)
