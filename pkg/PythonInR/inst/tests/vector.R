q("no")
Rdevel

library(PythonInR)
library(testthat)
library(typehints)

## ---------------------------
## NULL
## ---------------------------
pySet("x", NULL)
expect_equal(pyType("x"), "NoneType")
expect_equal(pyGet("x"), NULL)

pySet("x", Inf)
expect_equal(pyType("x"), "float")
expect_equal(pyGet("x"), Inf)

pySet("x", -Inf)
expect_equal(pyType("x"), "float")
expect_equal(pyGet("x"), -Inf)

pySet("x", NA) ## FIXME:
pyPrint("x")
expect_equal(pyType("x"), "NoneType")
expect_equal(pyGet("x"), NULL)

## ---------------------------
## Basic Types
## ---------------------------
## logical
pySet("x", TRUE)
expect_equal(pyType("x"), "bool")
expect_equal(pyGet("x"), TRUE)

## int
pySet("x", th.int(0L))
expect_equal(pyType("x"), "int")
expect_equal(pyGet("x"), 0L)

## long
pySet("x", 0L)
expect_equal(pyType("x"), "long")
expect_equal(pyGet("x"), 0L)

## double
pySet("x", 0)
expect_equal(pyType("x"), "float")
expect_equal(pyGet("x"), 0)

## string
pySet("x", th.string(""))
expect_equal(pyType("x"), "str")
expect_equal(pyGet("x"), "")

## unicode
pySet("x", "")
expect_equal(pyType("x"), "unicode")
expect_equal(pyGet("x"), "")

## ---------------------------
## vector (N=1)
## ---------------------------
## logical
pySet("x", th.vector(TRUE))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is bool"))
expect_equal(pyGet("x"), TRUE)

## int ## FIXME: (TODO: ich muss noch zusätzliche type hints erstellen )
## th.vector_int
## pySet("x", th.vector(th.int(0L)))
pySet("x", tyhi(0L, c("vector", "int")))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), 0L)

## long
pySet("x", th.vector(0L))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), 0L)

## double
pySet("x", th.vector(0))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), 0)

## string ## FIXME:
pySet("x", tyhi("", c("vector", "string")))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), "")

## unicode
pySet("x", th.vector(""))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), "")

## ---------------------------
## vector (N>1)
## ---------------------------
## logical
pySet("x", c(TRUE, FALSE, TRUE))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is bool"))
expect_equal(pyGet("x"), c(TRUE, FALSE, TRUE))

## int ## FIXME:
pySet("x", th.int(-3:3))
expect_equal(pyType("x"), "PythonInR.vector")
pyExecp("x")
expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), -3:3)

## long
pySet("x", -3:3)
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), -3:3)

## double
pySet("x", as.double(-300:300))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), as.double(-300:300))

## string (empty)
pySet("x", th.string(rep("", 100)))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("", 100))

## string (latin1)
pySet("x", th.string(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))

## unicode
pySet("x", rep("Hällö Wörld!", 100))
expect_equal(pyType("x"), "PythonInR.vector")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))

## ---------------------------
## tlist (N=1) (FIXME)
## ---------------------------
## logical
pySet("x", th.tlist(TRUE))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is bool"))
expect_equal(pyGet("x"), TRUE)

## int
pySet("x", th.list_int(0L))
expect_equal(pyType("x"), "tlist")
pyExecp("x")
expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), 0L)

## long
pySet("x", th.list(0L))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), 0L)

## double
pySet("x", th.list(0))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), 0)

## string
pySet("x", th.list_str(""))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), "")

## unicode
pySet("x", th.list("äöü"))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), "äöü")

## ---------------------------
## tlist (N>1) (FIXME)
## ---------------------------
## logical
pySet("x", th.list(c(TRUE, FALSE, TRUE)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is bool"))
expect_equal(pyGet("x"), c(TRUE, FALSE, TRUE))

## int
pySet("x", th.list_int(-3:3))
expect_equal(pyType("x"), "tlist")
pyExecp("x")
expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), -3:3)

## long
pySet("x", th.list(-3:3))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), -3:3)

## double
pySet("x", th.list(as.double(-3:3)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), as.double(-3:3))

## string (empty)
pySet("x", th.list_str(rep("", 30)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("", 30))

## string (latin1)
pySet("x", th.list_str(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))

## unicode
pySet("x", th.list(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))


## ---------------------------
## list (N=1)
## ---------------------------
## logical
pySet("x", th.list(TRUE))
expect_equal(pyType("x"), "list")
expect_equal(pyGet("x", simplify=TRUE), TRUE)
expect_equal(pyGet("x", simplify=FALSE), list(TRUE))

## int
pySet("x", th.list_int(0L))
expect_equal(pyType("x"), "list")
pyExecp("x")
expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), 0L)

## long
pySet("x", th.list(0L))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), 0L)

## double
pySet("x", th.list(0))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), 0)

## string
pySet("x", th.list_str(""))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), "")

## unicode
pySet("x", th.list("äöü"))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), "äöü")

## ---------------------------
## list (N>1)
## ---------------------------
## logical
pySet("x", th.list(c(TRUE, FALSE, TRUE)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is bool"))
expect_equal(pyGet("x"), c(TRUE, FALSE, TRUE))

## int
pySet("x", th.list_int(-3:3))
expect_equal(pyType("x"), "tlist")
pyExecp("x")
expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), -3:3)

## long
pySet("x", th.list(-3:3))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), -3:3)

## double
pySet("x", th.list(as.double(-3:3)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), as.double(-3:3))

## string (empty)
pySet("x", th.list_str(rep("", 30)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("", 30))

## string (latin1)
pySet("x", th.list_str(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))

## unicode
pySet("x", th.list(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "tlist")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))

## ---------------------------
## tuple (N=1)
## ---------------------------
## logical
pySet("x", th.tuple(TRUE))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is bool"))
expect_equal(pyGet("x"), TRUE)

## int
pySet("x", th.tuple_int(0L))
expect_equal(pyType("x"), "ttuple")
pyExecp("x")
expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), 0L)

## long
pySet("x", th.tuple(0L))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), 0L)

## double
pySet("x", th.tuple(0))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), 0)

## string
pySet("x", th.tuple_str(""))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), "")

## unicode
pySet("x", th.tuple("äöü"))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), "äöü")

## ---------------------------
## tuple (N>1)
## ---------------------------
## logical
pySet("x", th.tuple(c(TRUE, FALSE, TRUE)))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is bool"))
expect_equal(pyGet("x"), c(TRUE, FALSE, TRUE))

## int
pySet("x", th.tuple_int(-3:3))
expect_equal(pyType("x"), "ttuple")
pyExecp("x")
expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), -3:3)

## long
pySet("x", th.tuple(-3:3))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), -3:3)

## double
pySet("x", th.tuple(as.double(-3:3)))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), as.double(-3:3))

## string (empty)
pySet("x", th.tuple_str(rep("", 30)))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("", 30))

## string (latin1)
pySet("x", th.tuple_str(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))

## unicode
pySet("x", th.tuple(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "ttuple")
expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))

## ---------------------------
## numpy (N=1)
## ---------------------------
## logical
pySet("x", th.numpy(TRUE))
pyExecp("x")
expect_equal(pyType("x"), "ndarray")
## expect_true(pyGet("x.dtype()"))
expect_equal(pyGet("x"), TRUE)

## int
## th.int_numpy ## FIXME: int type for ndarray!
pySet("x", th.numpy(0L))
expect_equal(pyType("x"), "ndarray")
## expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), 0L)

## long
pySet("x", th.numpy(0L))
expect_equal(pyType("x"), "ndarray")
##expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), 0L)

## double
pySet("x", th.numpy(0))
expect_equal(pyType("x"), "ndarray")
##expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), 0)

## string
pySet("x", th.numpy(""))
expect_equal(pyType("x"), "ndarray")
##expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), "")

## unicode
pySet("x", th.numpy("äöü"))
expect_equal(pyType("x"), "ndarray")
##expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), "äöü")

## ---------------------------
## numpy (N>1)
## ---------------------------
## logical
pySet("x", th.numpy(c(TRUE, FALSE, TRUE)))
expect_equal(pyType("x"), "ndarray")
##expect_true(pyGet("x.dtype is bool"))
expect_equal(pyGet("x"), c(TRUE, FALSE, TRUE))

## int
pySet("x", th.numpy(-3:3))
expect_equal(pyType("x"), "ndarray")
pyExecp("x")
pyExecp("__R__._get_r_type_numpy(x)")
##expect_true(pyGet("x.dtype is int"))
expect_equal(pyGet("x"), -3:3)

## long
pySet("x", th.numpy(-3:3))
expect_equal(pyType("x"), "ndarray")
## expect_true(pyGet("x.dtype is long"))
expect_equal(pyGet("x"), -3:3)

## double
pySet("x", th.numpy(as.double(-3:3)))
expect_equal(pyType("x"), "ndarray")
## expect_true(pyGet("x.dtype is float"))
expect_equal(pyGet("x"), as.double(-3:3))

## string (empty)
pySet("x", th.numpy(rep("", 30)))
expect_equal(pyType("x"), "ndarray")
## expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("", 30))

## string (latin1)
pySet("x", th.numpy(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "ndarray")
## expect_true(pyGet("x.dtype is str"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))

## unicode
pySet("x", th.numpy(rep("Hällö Wörld!", 100)))
expect_equal(pyType("x"), "ndarray")
## expect_true(pyGet("x.dtype is unicode"))
expect_equal(pyGet("x"), rep("Hällö Wörld!", 100))
