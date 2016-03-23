
library(slam)

simple_triplet_matrix


x <- setNames(1:3, paste("x", 1:3, sep=""))
x
print(x)


typeof(x)

rn <- paste("R", 1:3, sep="")
cn <- paste("C", 1:3, sep="")
matrix(1:9, 3, dimnames=list(rn, cn))

matrix(1:90, 3)

library(slam)
x <- simple_triplet_matrix(c(1,3), c(1,3), 1:2, dimnames=list(rn, cn))
x
str(x)
Str
