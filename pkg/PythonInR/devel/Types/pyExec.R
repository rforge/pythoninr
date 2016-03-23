q("no")
R

library("PythonInR")
library("typehints")
pyGet("z")


fun <- function() {
	pyExec("3/0")	
	3
}
fun()

x <- 1:3

pySet("x", x)
pyExecp("x")
pyGet("x")

pySet("x", th.list(x))
pyExecp("x")
pyGet("x")

th.tuple_int <- function(x) tyhi(x, c("tuple", "int"))
pySet("x", th.tuple_int(x))
pyExecp("x")
pyGet("x")



library(slam)

