q("no")
Rdevel

library(PythonInR)
## library(typehints)

x <- th.int(3)
comment(x)

x <- tyhi(3, "int")
tyhi(x)
comment(x) <- "int"
comment(x)


pySet("x", c(TRUE, FALSE, TRUE))
pyExecp("x")

pySet("x", 3L)
pyExecp("x")
pyExecp("type(x)")

pySet("x", th.int(3L))
pyExecp("x")
pyExecp("type(x)")

pySet("x", 3)
pyExecp("x")

pySet("x", th.string("Österreich"))
pyExecp("type(x); print(x)")

pySet("x", "Österreich")
pyExecp("type(x); print(x)")

pyGet("x")

pySet("x", th.int(3L))
pyExecp("type(x)")

##' Vector
pySet("x", c(TRUE, FALSE, TRUE))
pyExecp("x")

pySet("x", 1:3)
pyExecp("x")

pySet("x", th.int(1:3))
pyExecp("x")

pySet("x", runif(3))
pyExecp("x")

pySet("x", LETTERS)
pyExecp("x")

pySet("x", th.string(LETTERS))
pyExecp("x")


2147483647L
as.integer(2147483648)
pyExec("overflow = 2147483648L")
pyExecp("overflow")
pyGet("overflow")


x <- 3
.Call("Test_add_typehint", x, "hallo")

attributes(y)
attributes(x)

type <- function(x) .Call("c_to_r_integer",.Call("r_GetR_Container", x))
ty <- function(x) .Call("test_r_flags", x)

d <- data.frame(1)
v <- c(1, 2)   ## IS_NUMERIC; IS_LIST; isVector; isVectorAtomic
m <- matrix(1) ## IS_NUMERIC; IS_LIST; isArray; isMatrix; isVector; isVectorAtomic
a <- array(1)  ## IS_NUMERIC; IS_LIST; isArray; isVector; isVectorAtomic
l <- list(1)
e <- new.env()

ty(v)
type(v)

## List
type(setNames(list(1), ""))

ty(m)
type(m)
type(a)
type(l)
type(e)

ty(v)
ty(m)
ty(a)
ty(d)
ty(l)

type(cbind(list(2)))
type(data.frame(2))
type(data.frame(list(2)))


type(NULL)

library(slam)
x <- simple_triplet_matrix(1, 1, 1)
type(x)

type()

