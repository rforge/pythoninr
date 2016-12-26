q("no")
library(PythonInR)
source("utility.R")
pyExecp("import gc")

pySet("x", 3)
pySet("y", 2)
x <- pyObject("x")
y <- pyObject("y")

z <- pyGet("x")
z <- pyGet("x", autoTypecast=FALSE)
pyExecp("gc.collect()")
pyExecp("x")

pyExecp("x")
pyType("x")
pyRef(z)

PythonInR:::getTypeInfo("x")
pyObject("x")



for (i in 1:30) {
    pyGet("x", autoTypecast=FALSE)
    pyExecp("gc.collect()")
}

for (i in 1:100) x + y
for (i in 1:100) 2 + x
for (i in 1:100) x + 2

for (i in 1:100) x * y
for (i in 1:100) 2 * x
for (i in 1:100) x * 2

for (i in 1:100) x + y
for (i in 1:100) 2 + x
for (i in 1:100) x + 2

for (i in 1:100) x + y
for (i in 1:100) 2 + x
for (i in 1:100) x + 2

`^.PythonInR_Object` <- function(a, b) PythonInR:::pyOperator("**", a, b)

x
x**2
x**3


