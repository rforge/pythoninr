q("no")
Rdevel

#' # pyGet
require(testthat)
require(PythonInR)
invisible(capture.output(pyConnect()))

pyExec("x = int(-2147483648)")
pyGet("x")

pyExec("x = int(2147483648)")
pyGet("x")


pyExec("x = __R__.tlist([3, -2147483648, 21407483648, 7, -0, 1], int)")
pyExecp("x[2]")
pyExecp("type(x[2])")
z <- pyGet("x")
class(z)
z

pyExec("x = __R__.tlist([3, -2147483648, 21407483648.0, 7, -0, 1], int)")
pyExecp("x[2]")
pyExecp("type(x[2])")
z <- pyGet("x")
class(z)
z

#' ## Logical (only NA)
as.logical(NA)
pySet("x", as.logical(NA))
pyPrint("x")
pyExecp("type(x)")
pyGet("x") # should return NULL

x <- c(TRUE, NA, FALSE)
pySet("x", x)
expect_that(pyGet("x"), equals(x))

as.integer(-2147483647)
pyExec("x = int(-2147483648)")
pyPrint("x")
pyGet("x")

as.integer(-2147483648)
pyExec("x = int(-2147483648)")
pyPrint("x")
pyGet("x")

#' ## Integer (only NA)
pySet("x", as.integer(NA))
pyPrint("x")
pyExecp("type(x)")
pyGet("x")

pySet("x", c(1L, NA, 3L))
pyPrint("x")
pyExecp("type(x)")
pyGet("x")

#' ## Numeric 
## Is OK
pySet("x", 0)
pySet("x", as.numeric(NA))
pyPrint("x")
pyExecp("type(x)")
pyGet("x")

pySet("x", as.numeric(NaN))
pyPrint("x")
pyExecp("type(x)")
pyGet("x")

pySet("x", as.numeric(Inf))
pyPrint("x")
pyExecp("type(x)")
pyGet("x")

pySet("x", as.numeric(-Inf))
pyPrint("x")
pyExecp("type(x)")
pyGet("x")

nchar(as.character(NA))
#' ## Character
## Is OK
pySet("x", as.character(NA))
pyPrint("x")
pyExecp("type(x)")
pyGet("x")

