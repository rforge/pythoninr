
##is.PythonInR_Object <- function(x) inherits(x, "PythonInR_Object")

pyOperator <- function(operator, a, b) {
    tmp_name <- "__R__.namespace['__temp__']"
    if ( is.PythonInR_Object(a) & !is.PythonInR_Object(b) ) {
        pySet("__temp__", b, namespace="__R__.namespace")
        return(pyGet(sprintf("%s %s %s", pyRef(a), operator, tmp_name), FALSE))
    }
    if ( !is.PythonInR_Object(a) & is.PythonInR_Object(b) ) {
        pySet("__temp__", a, namespace="__R__.namespace")
        return(pyGet(sprintf("%s %s %s", tmp_name, operator, pyRef(b)), FALSE))
    }
    return( pyGet(sprintf("%s %s %s", pyRef(a), operator, pyRef(b)), FALSE) )
}

`+.PythonInR_Object` <- function(a, b) pyOperator("+", a, b)
`*.PythonInR_Object` <- function(a, b) pyOperator("*", a, b)
`-.PythonInR_Object` <- function(a, b) pyOperator("-", a, b)
`/.PythonInR_Object` <- function(a, b) pyOperator("/", a, b)

## TODO:
## in
## //
## &
## ^
## |
## **
## is
## is not
## []
## <<
## %
## not
## >>
## :
## <
## <=
## ==
## !=
## >=
## >


##  ---------------------------------------------------------
##  pyRef
##  ==========
##' @title get the location (reference) of an \code{PythonInR_Object}
##'
##' @description The function \code{pyRef} return the variable name
##'              of an virtual Python object.
##' @param x an PythonInR_Object
##' @examples
##' \dontshow{PythonInR:::pyCranConnect()}
##' if ( pyIsConnected() ){
##' x <- pyObject("sys")
##' pyRef(x)
##' ## [1] "sys"
##' }
##  ---------------------------------------------------------
pyRef <- function(x) {
    if ( inherits(x, "pyFunction") ) return(attr(x, "name"))
    if ( inherits(x, "PythonInR_Object") ) return(x$.name)
    NULL
}

