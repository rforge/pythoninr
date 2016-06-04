q("no")
Rdevel
library(PythonInR)

pyExecp("x = [1, 2, 3]")
x <- pyGet0("x")
x[0:3]


