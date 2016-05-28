q("no")
Rdevel

library("PythonInR")
## pyExec("import numpy as np")
A <- array(seq_len(2*3*4), dim=c(2,3,4))
A[1, 1, 1]
A[1, 1, 2]
A[1, 1, 3]
length(A)
typeof(A)

pySet("x", A)
pyExecp("x")
pySet("x", th.int(A))
pyExecp("x")
pySet("x", th.numpy(A))
pyExecp("x")
pyExecp("x[1, 1, 1]")

pyExecp("x")


x <- A
aperm(x, rev(seq_len(length(dim(x)))))

BEGIN.Python()
import numpy as np
a = np.arange(2, 3, 4)
a
c = np.arange(24).reshape(2,3,4)
c[0, 0, 0]
c[0, 0, 1]
c.shape
END.Python

PythonInR:::pySetSimple("x", A)
x <- PythonInR:::pyGetSimple("x")
x
pyExecp("x")

all(x == A)

dim(A)

q("no")

Rdevel
library(PythonInR)

.Call("Test_permute_array_to_numpy", A, PACKAGE="PythonInR")

.Call("Test_R_eval_1_arg", "function(x) length(x)", 1:3, PACKAGE="PythonInR")
.Call("Test_R_eval_1_arg", "function(x) dim(x)", matrix(1:9, 3), PACKAGE="PythonInR")
