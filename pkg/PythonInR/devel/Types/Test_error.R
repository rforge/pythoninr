
q("no")
R

library(PythonInR)

.Call("Test_PythonInR_error", "some error", PACKAGE="PythonInR")


.Call("Test_Py_call_1_arg", "sum", list(1, 2, 3), PACKAGE="PythonInR")

