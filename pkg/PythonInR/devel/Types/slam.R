
q("no")
R

library("PythonInR")
library("slam")

M <- matrix(1:9, 3, 3)
rownames(M) <- paste("r", 1:3, sep="_")
colnames(M) <- paste("c", 1:3, sep="_")
M <- slam:::as.simple_triplet_matrix(M)
M
PythonInR:::pySetSimple("x", M)
pyExecp("x")
x <- PythonInR:::pyGetSimple("x")
x
x


str(M)

class(M)
is.list(M)


