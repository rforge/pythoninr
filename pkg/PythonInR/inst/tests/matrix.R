q("no")
Rdevel
library(PythonInR)
library(testthat)
library(typehints)

Mi <- matrix(1:12, 3)
colnames(Mi) <- LETTERS[1:4]
rownames(Mi) <- LETTERS[5:7]

Md <- matrix(as.double(1:12), 3)
colnames(Md) <- LETTERS[1:4]
rownames(Md) <- LETTERS[5:7]

Mc <- matrix(LETTERS[1:12], 3)
colnames(Mc) <- LETTERS[1:4]
rownames(Mc) <- LETTERS[5:7]

th.int_numpy <- function(x) tyhi(x, c("numpy", "int"))
th.str_numpy <- function(x) tyhi(x, c("numpy", "string"))
th.int_cvxopt <- function(x) tyhi(x, c("cvxopt", "int"))
th.str_cvxopt <- function(x) tyhi(x, c("cvxopt", "string"))

## ---------------------------
## Matrix
## ---------------------------
pySet("x", th.int(Mi))
expect_equal(pyType("x"), "PythonInR.matrix")
expect_true(pyGet("x.dtype is int"))
expect_equal(typeof(pyGet("x")), typeof(Mi))
expect_equal(pyGet("x"), Mi)

pySet("x", Mi)
expect_equal(pyType("x"), "PythonInR.matrix")
expect_true(pyGet("x.dtype is long"))
expect_equal(typeof(pyGet("x")), typeof(Mi))
expect_equal(pyGet("x"), Mi)

pySet("x", Md)
expect_equal(pyType("x"), "PythonInR.matrix")
expect_true(pyGet("x.dtype is float"))
expect_equal(typeof(pyGet("x")), typeof(Md))
expect_equal(pyGet("x"), Md)

pySet("x", th.string(Mc))
expect_equal(pyType("x"), "PythonInR.matrix")
expect_true(pyGet("x.dtype is str"))
expect_equal(typeof(pyGet("x")), typeof(Mc))
expect_equal(pyGet("x"), Mc)

pySet("x", Mc)
expect_equal(pyType("x"), "PythonInR.matrix")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(typeof(pyGet("x")), typeof(Mc))
expect_equal(pyGet("x"), Mc)

## ---------------------------
## Numpy Matrix TODO: (make a difference between int and long)
## ---------------------------
pySet("x", th.numpy(Mi))
expect_equal(pyType("x"), "ndarray")
expect_true(grepl("int", pyGet("str(x.dtype)")))
expect_equal(pyGet("x.dtype.kind"), "i")
expect_equal(typeof(pyGet("x")), typeof(Mi))
expect_equal(pyGet("x"), unname(Mi))

pySet("x", th.numpy(Md))
expect_equal(pyType("x"), "ndarray")
pyGet("str(x.dtype)")
expect_equal(pyGet("x.dtype.kind"), "f")
expect_equal(typeof(pyGet("x")), typeof(Md))
expect_equal(pyGet("x"), unname(Md))

pySet("x", th.str_numpy(Mc))
expect_equal(pyType("x"), "ndarray")
expect_true(grepl("S", pyGet("str(x.dtype)")))
expect_equal(pyGet("x.dtype.kind"), "S")
expect_equal(typeof(pyGet("x")), typeof(Mc))
expect_equal(pyGet("x"), unname(Mc))

pySet("x", th.numpy(Mc))
expect_equal(pyType("x"), "ndarray")
expect_true(grepl("U", pyGet("str(x.dtype)")))
expect_equal(pyGet("x.dtype.kind"), "U")
expect_equal(typeof(pyGet("x")), typeof(Mc))
expect_equal(pyGet("x"), unname(Mc))

## ---------------------------
## CvxOpt Matrix
## ---------------------------
pySet("x", th.cvxopt(Mi))
expect_equal(pyType("x"), "matrix")
expect_equal(pyGet("x.typecode"), "i")
expect_equal(typeof(pyGet("x")), typeof(Mi))
expect_equal(pyGet("x"), unname(Mi))

pySet("x", th.cvxopt(Md))
expect_equal(pyType("x"), "matrix")
expect_equal(pyGet("x.typecode"), "d")
expect_equal(typeof(pyGet("x")), typeof(Md))
expect_equal(pyGet("x"), unname(Md))

## ---------------------------
## Simple Triplet Matrix (NOTE: int and str doesn't work yet!)
## ---------------------------
library(slam)
SMi <- as.simple_triplet_matrix(Mi)
SMd <- as.simple_triplet_matrix(Md)
SMc <- as.simple_triplet_matrix(Mc)

pySet("x", th.int(SMi))
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
expect_true(pyGet("x.dtype is long"))
expect_equal(as.matrix(pyGet("x")), as.matrix(SMi))

pySet("x", SMi)
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
expect_true(pyGet("x.dtype is long"))
expect_equal(as.matrix(pyGet("x")), as.matrix(SMi))

pySet("x", SMd)
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
expect_true(pyGet("x.dtype is float"))
expect_equal(as.matrix(pyGet("x")), as.matrix(SMd))

pySet("x", th.string(SMc))
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(as.matrix(pyGet("x")), as.matrix(SMc))

pySet("x", SMc)
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(as.matrix(pyGet("x")), as.matrix(SMc))

th.scibsr <- function(x) tyhi(x, "scibsr")
th.scicoo <- function(x) tyhi(x, "scicoo")
th.scicsc <- function(x) tyhi(x, "scicsc")
th.scicsr <- function(x) tyhi(x, "scicsr")
th.scidia <- function(x) tyhi(x, "scidia")
th.scidok <- function(x) tyhi(x, "scidok")
th.scilil <- function(x) tyhi(x, "scilil")

pySet("x", th.scibsr(SMi))
expect_equal(pyType("x"), "bsr_matrix")
expect_true(pyGet("x.dtype.kind") == "i")
## expect_equal(pyGet("x"), SMi)

pySet("x", th.scicoo(SMi))
expect_equal(pyType("x"), "coo_matrix")
expect_true(pyGet("x.dtype.kind") == "i")

pySet("x", th.scicsc(SMi))
expect_equal(pyType("x"), "csc_matrix")
expect_true(pyGet("x.dtype.kind") == "i")

pySet("x", th.scicsr(SMi))
expect_equal(pyType("x"), "csr_matrix")
expect_true(pyGet("x.dtype.kind") == "i")

pySet("x", th.scidia(SMi))
expect_equal(pyType("x"), "dia_matrix")
expect_true(pyGet("x.dtype.kind") == "i")

pySet("x", th.scidok(SMi))
expect_equal(pyType("x"), "dok_matrix")
expect_true(pyGet("x.dtype.kind") == "i")

pySet("x", th.scilil(SMi))
expect_equal(pyType("x"), "lil_matrix")
expect_true(pyGet("x.dtype.kind") == "i")






pySet("x", th.tuple(as.double(-3:3)))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), as.double(-3:3))


pyExecp("x")
pyExecp("dir(x)")
pyExecp("x.dim")
pyExecp("x.dimnames")
pyExecp("x.rownames()")
pyExecp("x.to_list_of_list()")
pyExecp("x.to_numpy()")
pyExecp("print(x.to_cvxopt_matrix())")
M
pyExecp("import cvxopt as cvxopt")

pySet("x", M)
i <- 0
print(paste((i<-i+1), rep("-", 30), collapse=""))
pyExecp("x")
z <- pyGet("x")
matrix(z$values, nrow=z$nrow, ncol=z$ncol, dimnames=z$dimnames)
M

pyGet("h")
 
pySet("x", th.numpy(M))
pyType("x")
pyExecp("x")
pyGet("x")


Mi <- matrix(1:12, 3)
Md <- matrix(as.double(1:12), 3)

str(th.cvxopt(M))
pySet("x", th.cvxopt(M))
pyType("x")
pyExecp("x")

pySet("x", th.cvxopt(Mi))
pyType("x")
pyExecp("x")
pyExecp("print(x)")

pySet("x", th.cvxopt(Md))
pyType("x")
pyExecp("x")

class(cars)
pySet("x", cars)
3
pyType("x")
pyExecp("x")
pyExecp("dict(x)")


pyExecp("list(x)")
expect_equal(pyGet("x"), NULL)

matrix

pyExec('
mat = list()
for m in xrange(x.nrow()):
	col = list()
	for n in xrange(x.ncol()):
		col.append(x[(n * x.nrow()) + m])
	mat.append(col)
')
pyExecp('mat')

pyExecp('import numpy as np')
pyExecp('print(np.array(x).reshape(x.dim[::-1]).transpose())')


## ---------------------------
## Simple Triple Matrix
## ---------------------------
q("no")
Rdevel
library(PythonInR)
library(slam)
ls("package:slam")
library(testthat)

S <- simple_triplet_matrix(1:3, 1:3, as.numeric(3:5))
pySet("x", S)
pyExecp("x")
pyExecp("x.to_numpy()")
x <- pyGet("x")

str(S)
str(x)
simple_triplet_matrix(x$i, x$j, x$v, x$nrow, x$ncol, x$dimnames)

z <- rbind(list(NULL, 3, "abcd"), list(0L, TRUE, function(x) 0))
typeof(z)



q("no")
Rdevel
library(PythonInR)

M <- matrix(1:9, 3)
colnames(M) <- LETTERS[1:3]
rownames(M) <- LETTERS[4:6]
M
attributes(M)

pySet("M", M)
pyExecp("M")
pyExecp("M.matrix")


q("no")
library(PythonInR)

ty <- function(x) .Call("Test_Py_GetContainer_Type", x)

pyExec("y = [1, 2]")
ty("y")

pySet("x", 1:3)
ty("x")

q("no")
Rdevel
x <- matrix(0L, 2e4, 1e4)

comment(x) <- c("cvxopt", "int")

library(typehints)

typehint
tyhi

fun <- function(x) x
y <- fun(x)

z <- 3
tyhii <- function(x, value) {
	name <- as.character((x))
	print(name)
	attr(get(name, parent.frame()), value)
}
tyhii(z, "abd")


z <- tyhi(x, "abc")


