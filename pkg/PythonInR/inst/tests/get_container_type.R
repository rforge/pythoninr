
q("no")
Rdevel

library(PythonInR)

pySet("x", 1:3)
pyExecp("x")


.Call("Test_Py_GetContainer_Type", "x")

pyExec("import gc")
pyExecp("dir(gc)")
pyExecp("gc.collect()")
