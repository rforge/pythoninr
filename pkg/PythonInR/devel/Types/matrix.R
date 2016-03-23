3
q("no")
R
##R -d gdb --vanilla
##run

(1, 2)

library("PythonInR")
pyExec("import numpy as np")

M <- matrix(1:9, 3, 3)
rownames(M) <- paste("r", 1:3, sep="_")
colnames(M) <- paste("c", 1:3, sep="_")

PythonInR:::pySetSimple("x", M)
x <- PythonInR:::pyGetSimple("x")

PythonInR:::pyGetSimple("x")

pyExec("y = x.toNumpyArray()")
PythonInR:::pyGetSimple("y.tolist()")

pyExec("y = x.toBsr()")
PythonInR:::pyGetSimple("y.tolist()")

pyExec("y = x.toNumpyArray()")
PythonInR:::pyGetSimple("y.tolist()")
pyExecp("isinstance(y, np.ndarray)")

pyExec("y = x.toNumpyMatrix()")
pyExecp("isinstance(y, np.ndarray)")

pyExec("y = x.toNumpyArray()")
PythonInR:::pyGetSimple("y.tolist()")


system("python")

pyExecp("x")
pyExecp("x.names is None")
pyExecp("type(x)")
pyExecp("type(x).__name__")
pyExecp("isinstance(x, dict)")

pyExecp("dir()")

BEGIN.Python()

(1,2)
tuple([1,2,3])

"%i %i" % (3, 2)

np.array(4)
y.__module__
dir(y.__class__)
y.__class__.__name__
dir(y)


x = uuid.uuid1()


x

isinstance(__R__.np.array, list)
dir(__R__.np.array)
__R__.np.array.__class__


dir(x)
dir()
type(x.toNumpyArray()).__name__

END.Python



