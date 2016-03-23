


library(NLP)

.Call("init_PY_To_R_Typecast", PACKAGE="PythonInR")

## a tree in nltk is a list with a label
## since in python a class is just a dict
vp <- Tree('VP', list(Tree('V', list('saw')), Tree('NP', list('him'))))

R
library("PythonInR")
PythonInR:::r_to_py_postprocessing
ls("")

pySet("x", array(1))
pySet("x", th.tuple(list()))
pyPrint("x")

fun <- function(x) x

z <- .Call("r_call_function", "fun", x=list(1:3), PACKAGE="PythonInR")
str(z)

x <- 1:3
x <- array(1:3)
.Call("r_to_py_preprocessing", x, "array", PACKAGE="PythonInR")

PythonInR:::r_to_py_preprocessing[['array']]
get
assignInNamespace("array", function(x) 3,)
assign("array", function(x) 3, getFromNamespace("r_to_py_preprocessing", "PythonInR"))
.Call("r_to_py_preprocessing", x, "array", PACKAGE="PythonInR")

R -d gdb --vanilla

3
q("no")

R
library(PythonInR)

PythonInR:::pySetSimple("v", 1:4)
pyPrint("v")
PythonInR:::pySetSimple("v", LETTERS)
pyPrint("v")
pyPrint("v.values")
pyDir()


x <- 1:3
names(x) <- paste("x", x, sep="")
PythonInR:::pySetSimple("v", x)
pyPrint("v")
	

pyExecp("v = R.vector([1,2], None, 'integer')")
pySet("values", as.list(1:4), namespace="v")
pyPrint("v")


pyCall("R.vector", list(list(1,2), NULL, "integer"))




PythonInR:::pySetSimple

v <- pyObject("v")
v$values


z <- 1:4
class(z)
class(z) <- c("abc")

.Call("r_get_class", z, PACKAGE="PythonInR")

z <- data.frame(3)
attributes(z)

pySet("x", 3L)
pyPrint("type(x)")

pySet("x", th.int(3L))
pyPrint("type(x)")

pyDir("R")

pyExec("import R as R")

PythonInR:::pySetSimple("v", 1:4)

x <- 1:3
names(x) <- paste("x", x, sep="")
PythonInR:::pySetSimple("v", x)
pyPrint("v")

pyDir("R")

v <- 1:5
pySet("x", as.list(v))
pySet

BEGIN.Python()
x

END.Python

`comment<-`

?attributes
v <- 1:5
attributes(v)$srcref <- "a"
v
attributes(v)
attributes(v)$srcfile <- "b"
v

M <- matrix(1:4)
M
.Call("test_r_flags", M, PACKAGE="PythonInR")

.Call("test_r_flags", list(1:4), PACKAGE="PythonInR")

file.path(find.package("PythonInR"), "python")

x <- 1
attributes(x)$source <- "abc"
x

getAttrib(s, install("comment"))

class(x)

R
library(PythonInR)

A <- array(1:24, dim=c(2, 3, 4))
PythonInR:::pySetSimple("x", A)
pyExecp("x")



