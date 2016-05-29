q("no")
Rdevel
library(PythonInR)
library(testthat)
library(typehints)

## ---------------------------
## Data Frame
## ---------------------------
pySet("x", cars)
pyExecp("dict(x)")
pyExecp("x['speed']")
pyExecp("x['dist']")
pyGet("x['dist']")
z <- pyGet("x")
class(z)
str(z)
str(cars)

expect_equal(pyType("x"), "PythonInR.data_frame")
expect_equal(typeof(pyGet("x")), typeof(Mi))
expect_equal(pyGet("x"), Mi)


args(data.frame)
as.data.frame

y <- as.list(cars)
y <- unname(y)
str(as.data.frame(y, col.names=c("a", "b")))

x <- y

f = function(x) {
    if ('colnames' %in% names(x)) {
       return( base::as.data.frame(x$data, x$rownames, col.names=x$colnames, stringsAsFactors=FALSE) )
    }
    return( base::as.data.frame(x$data, x$rownames, stringsAsFactors=FALSE) )
}
