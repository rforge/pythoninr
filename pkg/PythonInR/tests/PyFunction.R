#' # pyImport
require(testthat)
require(PythonInR)
invisible(capture.output(pyConnect()))

expect_that(pyExec("import os"), equals(0))
fun <- pyFunction("os.getcwd")
expect_true( inherits(fun, "PythonInR_Object") )
expect_equal(fun(), getwd())
