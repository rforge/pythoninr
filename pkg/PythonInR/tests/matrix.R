if (FALSE) {
    q("no")
    Rdevel
}

library(PythonInR)
library(testthat)

is_python3 <- pyGet("sys.version_info[0]") == 3L
is_numpy_installed <- pyGet("__R__.PythonInR_FLAGS['useNumpy']")
is_cvxopt_installed <- pyGet("__R__.PythonInR_FLAGS['useCvxOpt']")

Mi <- matrix(1:12, 3)
colnames(Mi) <- LETTERS[1:4]
rownames(Mi) <- LETTERS[5:7]

Md <- matrix(as.double(1:12), 3)
colnames(Md) <- LETTERS[1:4]
rownames(Md) <- LETTERS[5:7]

Mc <- matrix(LETTERS[1:12], 3)
colnames(Mc) <- LETTERS[1:4]
rownames(Mc) <- LETTERS[5:7]

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
if ( is_python3 ) {
	expect_true(pyGet("x.dtype is int"))
} else {
	expect_true(pyGet("x.dtype is long"))
}
expect_equal(typeof(pyGet("x")), typeof(Mi))
expect_equal(pyGet("x"), Mi)

pySet("x", Md)
expect_equal(pyType("x"), "PythonInR.matrix")
expect_true(pyGet("x.dtype is float"))
expect_equal(typeof(pyGet("x")), typeof(Md))
expect_equal(pyGet("x"), Md)

pySet("x", th.string(Mc))
expect_equal(pyType("x"), "PythonInR.matrix")
if ( is_python3 ) {
	expect_true(pyGet("x.dtype is bytes"))
} else {
	expect_true(pyGet("x.dtype is str"))
}
expect_equal(typeof(pyGet("x")), typeof(Mc))
expect_equal(pyGet("x"), Mc)

pySet("x", Mc)
expect_equal(pyType("x"), "PythonInR.matrix")
if ( is_python3 ) {
	expect_true(pyGet("x.dtype is str"))
} else {
	expect_true(pyGet("x.dtype is unicode"))
}
expect_equal(typeof(pyGet("x")), typeof(Mc))
expect_equal(pyGet("x"), Mc)

## ---------------------------
## Numpy Matrix
## ---------------------------
pySet("x", th.numpy(Mi))
expect_equal(pyType("x"), "ndarray")
expect_true(grepl("int", pyGet("str(x.dtype)")))
expect_equal(pyGet("x.dtype.kind"), "i")
expect_equal(typeof(pyGet("x")), typeof(Mi))
expect_equal(pyGet("x"), unname(Mi))

pySet("x", th.numpy(Md))
expect_equal(pyType("x"), "ndarray")
expect_equal(pyGet("x.dtype.kind"), "f")
expect_equal(typeof(pyGet("x")), typeof(Md))
expect_equal(pyGet("x"), unname(Md))

pySet("x", th.numpy_str(Mc))
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

pySet("x", SMi)
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
expect_true(pyGet("x.dtype is int"))
expect_equal(as.matrix(pyGet("x")), as.matrix(SMi))

## NOTE: For slam int is default and long is deactivated currently.
## pySet("x", SMi)
## expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
## expect_true(pyGet("x.dtype is long"))
## expect_equal(as.matrix(pyGet("x")), as.matrix(SMi))

pySet("x", SMd)
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
expect_true(pyGet("x.dtype is float"))
expect_equal(as.matrix(pyGet("x")), as.matrix(SMd))

pySet("x", th.string(SMc))
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
if ( is_python3 ) {
	expect_true(pyGet("x.dtype is str"))
} else {
	expect_true(pyGet("x.dtype is unicode"))
}
expect_equal(as.matrix(pyGet("x")), as.matrix(SMc))

pySet("x", SMc)
expect_equal(pyType("x"), "PythonInR.simple_triplet_matrix")
if ( is_python3 ) {
	expect_true(pyGet("x.dtype is str"))
} else {
	expect_true(pyGet("x.dtype is unicode"))
}
expect_equal(as.matrix(pyGet("x")), as.matrix(SMc))

## ---------------------------
## CvxOpt Matrix
## ---------------------------
## CvxOpt typecodes:
## "d": int and float
## "z": complex
## source: http://cvxopt.org/userguide/matrices.html
pySet("x", th.cvxopt(SMi))
expect_equal(pyType("x"), "spmatrix")
expect_true(pyGet("x.typecode") == "d")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

pySet("x", th.cvxopt(SMd))
expect_equal(pyType("x"), "spmatrix")
expect_true(pyGet("x.typecode") == "d")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

## ---------------------------
## Scipy Matrices
## ---------------------------
pySet("x", th.scibsr(SMi))
expect_equal(pyType("x"), "bsr_matrix")
expect_true(pyGet("x.dtype.kind") == "i")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

pySet("x", th.scicoo(SMi))
expect_equal(pyType("x"), "coo_matrix")
expect_true(pyGet("x.dtype.kind") == "i")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

pySet("x", th.scicsc(SMi))
expect_equal(pyType("x"), "csc_matrix")
expect_true(pyGet("x.dtype.kind") == "i")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

pySet("x", th.scicsr(SMi))
expect_equal(pyType("x"), "csr_matrix")
expect_true(pyGet("x.dtype.kind") == "i")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

pySet("x", th.scidia(SMi))
expect_equal(pyType("x"), "dia_matrix")
expect_true(pyGet("x.dtype.kind") == "i")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

pySet("x", th.scidok(SMi))
expect_equal(pyType("x"), "dok_matrix")
expect_true(pyGet("x.dtype.kind") == "i")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

pySet("x", th.scilil(SMi))
expect_equal(pyType("x"), "lil_matrix")
expect_true(pyGet("x.dtype.kind") == "i")
expect_equal(as.matrix(pyGet("x")), unname(as.matrix(SMi)))

