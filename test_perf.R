p_values <- c(a=0.5, b=0.1, c=0.9)
print(names(sort(p_values, decreasing = FALSE))[1L])
print(names(p_values)[which.min(p_values)])
