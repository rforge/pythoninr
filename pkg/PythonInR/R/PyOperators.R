
is.PythonInR_Object <- function(x) inherits(x, "PythonInR_Object")

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


pyRef <- function(x) {
    if ( inherits(x, "pyFunction") ) return(attr(x, "name"))
    if ( inherits(x, "PythonInR_Object") ) return(x$.name)
    NULL
}

