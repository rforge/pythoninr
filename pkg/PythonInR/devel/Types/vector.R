
3
q("no")
R
##R -d gdb --vanilla
##run

library("PythonInR")

PythonInR:::pySetSimple("x", 1:4)
x <- PythonInR:::pyGetSimple("x")
x <- PythonInR:::pyGetSimple("x")
x <- PythonInR:::pyGetSimple("x")

pyExecp("np.array(x.values).tolist()")

pyExecp("x")
pyExecp("x.names is None")
pyExecp("type(x)")
pyExecp("type(x).__name__")
pyExecp("isinstance(x, dict)")



BEGIN.Python()
x
END.Python
