if (FALSE) {
    q("no")
    Rdevel  
}

library(PythonInR)
library(testthat)

is_python3 <- pyGet("sys.version_info[0]") == 3L
is_numpy_installed <- pyGet("__R__.PythonInR_FLAGS['useNumpy']")

if ( is_numpy_installed ) {

Ai <- array(seq_len(2*3*4), dim=c(2,3,4))
Ad <- array(as.numeric(seq_len(2*3*4)), dim=c(2,3,4))
Ac <- array(LETTERS[seq_len(2*3*4)], dim=c(2,3,4))

## ---------------------------
## Array
## ---------------------------
pySet("x", th.int(Ai))
expect_equal(pyType("x"), "PythonInR.array")
expect_true(pyGet("x.dtype is int"))
expect_equal(typeof(pyGet("x")), typeof(Ai))
expect_equal(pyGet("x"), Ai)

pySet("x", Ai)
expect_equal(pyType("x"), "PythonInR.array")
if ( is_python3 ) {
	expect_true(pyGet("x.dtype is int"))	
} else {
	expect_true(pyGet("x.dtype is long"))	
}
expect_equal(typeof(pyGet("x")), typeof(Ai))
expect_equal(pyGet("x"), Ai)

pySet("x", Ad)
expect_equal(pyType("x"), "PythonInR.array")
expect_true(pyGet("x.dtype is float"))
expect_equal(typeof(pyGet("x")), typeof(Ad))
expect_equal(pyGet("x"), Ad)

pySet("x", th.string(Ac))
expect_equal(pyType("x"), "PythonInR.array")
if ( is_python3 ) {
	expect_true(pyGet("x.dtype is bytes"))
} else {
	expect_true(pyGet("x.dtype is str"))
}
expect_equal(typeof(pyGet("x")), typeof(Ac))
expect_equal(pyGet("x"), Ac)

pySet("x", Ac)
expect_equal(pyType("x"), "PythonInR.array")
if ( is_python3 ) {
	expect_true(pyGet("x.dtype is str"))
} else {
	expect_true(pyGet("x.dtype is unicode"))	
}
expect_equal(typeof(pyGet("x")), typeof(Ac))
expect_equal(pyGet("x"), Ac)

## ---------------------------
## Numpy Array
## ---------------------------
pySet("x", th.numpy_int(Ai))
expect_equal(pyType("x"), "ndarray")
expect_equal(pyGet("x.dtype.kind"), "i")
expect_equal(typeof(pyGet("x")), typeof(Ai))
expect_equal(pyGet("x"), Ai)

pySet("x", th.numpy(Ai))
expect_equal(pyType("x"), "ndarray")
expect_equal(pyGet("x.dtype.kind"), "i")
expect_equal(typeof(pyGet("x")), typeof(Ai))
expect_equal(pyGet("x"), Ai)

pySet("x", th.numpy(Ad))
expect_equal(pyType("x"), "ndarray")
expect_equal(pyGet("x.dtype.kind"), "f")
expect_equal(typeof(pyGet("x")), typeof(Ad))
expect_equal(pyGet("x"), Ad)

pySet("x", th.numpy_str(Ac)) ## FIXME! By the conversion I delete the typehint!
expect_equal(pyType("x"), "ndarray")
expect_equal(pyGet("x.dtype.kind"), "U")
expect_equal(typeof(pyGet("x")), typeof(Ac))
expect_equal(pyGet("x"), Ac)

pySet("x", th.numpy(Ac))
expect_equal(pyType("x"), "ndarray")
expect_equal(pyGet("x.dtype.kind"), "U")
expect_equal(typeof(pyGet("x")), typeof(Ac))
expect_equal(pyGet("x"), Ac)

## ---------------------------
## Check Indexing
## ---------------------------
pySet("x", th.numpy(Ai))
for (i in seq_len(2)) {
    for (j in seq_len(3)) {
        for (k in seq_len(4)) {
            expect_true(Ai[i, j, k] == pyGet(sprintf("x[%i, %i, %i]", i-1, j-1, k-1)))
        }
    }
}

}
