x <- c("MEAN1", "COV2", "ak3", "d0", "d01", "other")
orig <- x[-c(grep("^MEAN", x), grep("^COV", x), grep("^ak", x), grep("^d0$", x))]
new_way <- x[!grepl("^(MEAN|COV|ak|d0$)", x)]
print("Original:")
print(orig)
print("New way:")
print(new_way)

x_empty <- c("other", "something_else")
print(x_empty[-c(grep("^MEAN", x_empty), grep("^COV", x_empty), grep("^ak", x_empty), grep("^d0$", x_empty))])
print(x_empty[!grepl("^(MEAN|COV|ak|d0$)", x_empty)])
