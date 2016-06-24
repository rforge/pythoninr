library("PythonInR")

pySet("x", th.numpy(1:3))
pySet("y", th.numpy(2:4))
class(pyGet0("x"))

`+.ndarray` <- function(x, y) {
	pyGet0(sprintf("%s + %s", x$py.variableName, y$py.variableName))
}

x <- pyGet0("x")
y <- pyGet0("y")

class(x + y)
x + y


as.list

PythonInR:::pyIsCallable

e <- pyGet("z")
e
class()
capture.output(tryCatch(z <- pyGet("z"), error=function(e) NULL))
z


x <- 3
y <- x
comment(y) <- "list"
identical(th.list(x), x)
identical(th.list(x), y)

(comment(()) <- "list")
