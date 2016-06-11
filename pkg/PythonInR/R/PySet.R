# ------------------------------------------------------------------------------ 
#
#   SetPythonObjects
#
# ------------------------------------------------------------------------------

#  ---------------------------------------------------------
#  pySet
#  =====
#' @title assigns R objects to Python
#'
#' @description The function pySet allows to assign R objects to the Python 
#'              namespace, the conversion from R to Python is done automatically.
#' @param key a string specifying the name of the Python object.
#' @param value a R object which is assigned to Python. 
#' @param namespace a string specifying where the key should be located.
#'                   If the namespace is set to "__main__" the key will be
#'                   set to the global namespace. But it is also possible to
#'                   set attributes of objects e.g. the attribute name of
#'                   the object 'os'.
#' @details More information about the type conversion can be found in the README 
#'          file or at \url{http://pythoninr.bitbucket.org/}.
#' @examples
#' \dontshow{PythonInR:::pyCranConnect()}
#' pySet("x", 3)
#' pySet("M", diag(1,3))
#' pyImport("os")
#' pySet("name", "Hello os!", namespace="os")
#' ## In some situations it can be beneficial to convert R lists or vectors
#' ## to Python tuple instead of lists. One way to accomplish this is to change
#' ## the class of the vector to "tuple".
#' y <- c(1, 2, 3)
#' class(y) <- "tuple"
#' pySet("y", y)
#' ## pySet can also be used to change values of objects or dictionaries.
#' asTuple <- function(x) {
#'  class(x) <- "tuple"
#'  return(x)
#' }
#' pyExec("d = dict()")
#' pySet("myTuple", asTuple(1:10), namespace="d")
#' pySet("myList", as.list(1:5), namespace="d")
#  ---------------------------------------------------------
pySet <- function(key, value, namespace = "__main__"){    
    if ( pyConnectionCheck() ) return(invisible(NULL))
    check_string(key)

    x <- .Call("r_set_py", namespace, key, value)
    invisible(x)
}

# pySetSimple is a wrapper over the C function that users can
# ===========
# create new generic functions by using the function PythonInR:::pySetSimple
pySetSimple <- pySet

