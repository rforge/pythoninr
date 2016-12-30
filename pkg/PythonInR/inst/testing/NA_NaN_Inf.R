if (FALSE) {
	q("no")
	Rdevel	
}

#' # pyGet
require(testthat)
require(PythonInR)
invisible(capture.output(pyConnect()))

## if we get an integer it should give an NA instead of overflow
expect_warning(x <- pyGet("int(-2147483648)"))
expect_true( is.na(x) )
expect_warning( x <- pyGet("int(2147483648)") )
expect_true( is.na(x) )

pyExec("x = __R__.tlist([3, -2147483648, 21407483648, 7, -0, 1], int)")
expect_warning( z <- pyGet("x") )
expect_true( is.integer(z) )
expect_equal( which(is.na(z)), 2:3 )

pyExec("x = __R__.tlist([3, -2147483648, 21407483648.0, 7, -0, 1], int)")
expect_warning( z <- pyGet("x") )
expect_true( is.integer(z) )
expect_equal( which(is.na(z)), 2:3 )

## NOTE: in Python only float has a NA type
##       Therefore this is a bit difficult if we set the
##       typehint vector we get exactly back what we put in else
##       we get NULL which is not desireable but in most cases one
##       want's vectors of length 1 to be handeled as scalars 
##       and there we don't distiguish between NULL and NA, mainly
##       since even it would be conceptually nice it would introduce
##       more problems than it solves.
#' ## Logical (only NA)
pySet("x", as.logical(NA))
expect_true( pyType("x") == "NoneType" )
expect_true( is.null(pyGet("x")) )

pySet("x", th.vector(as.logical(NA)))
expect_true( pyType("x") == "PythonInR.vector" )
expect_true( is.na(pyGet("x")) )

x <- c(TRUE, NA, FALSE)
pySet("x", x)
expect_that(pyGet("x"), equals(x))

#' ## Integer (only NA)
pySet("x", as.integer(NA))
expect_true( pyType("x") == "NoneType" )
expect_true( is.null(pyGet("x")) )

x <- c(1L, NA, 3L)
pySet("x", x)
expect_equal( pyGet("x"), x )

#' ## Numeric 
pySet("x", as.numeric(NA))
expect_equal( pyGet("str(x)"), "nan" )
expect_true( pyType("x") == "float" )
expect_true( is.na(pyGet("x")) )

pySet("x", as.numeric(NaN))
expect_equal( pyGet("str(x)"), "nan" )
expect_true( pyType("x") == "float" )
expect_true( is.na(pyGet("x")) )

pySet("x", as.numeric(Inf))
expect_equal( pyGet("str(x)"), "inf" )
expect_true( pyType("x") == "float" )
expect_equal( pyGet("x"), Inf )

pySet("x", as.numeric(-Inf))
expect_equal( pyGet("str(x)"), "-inf" )
expect_true( pyType("x") == "float" )
expect_equal( pyGet("x"), -Inf )

#' ## Character
pySet("x", th.unicode(as.character(NA)))
expect_true( grepl("NA", pyGet("str(x)")) )
expect_true( pyType("x") %in% c(py2k="unicode", py3k="str") )
expect_equal( pyGet("x"), "NA" )

pySet("x", th.string(as.character(NA)))
expect_true( grepl("NA", pyGet("str(x)")) )
expect_true( pyType("x") %in% c(py2k="str", py3k="bytes") )
expect_equal( pyGet("x"), "NA" )
