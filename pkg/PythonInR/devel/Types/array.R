3
q("no")
R
##R -d gdb --vanilla
##run

library("PythonInR")
pyExec("import numpy as np")
A <- array(seq_len(2*3*4), dim=c(2,3,4))
A

PythonInR:::pySetSimple("x", A)
x <- PythonInR:::pyGetSimple("x")
x
pyExecp("x")

all(x == A)


