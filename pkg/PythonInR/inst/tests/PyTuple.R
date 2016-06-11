library(PythonInR)

pyExec('myPyTuple = (1, 2, 5, "Hello R!")')
# create a virtual Python tuple for an existing tuple
myTuple <- pyTuple("myPyTuple")
myTuple[0]
tryCatch({myTuple[1] <- "should give an error since tuple are not mutable"},
         error = function(e) print(e))
myTuple
# create a new Python tuple and virtual tuple

newTuple <- 
pyTuple('myNewTuple', th.list(list(1:3, 'Hello Python')))
newTuple[1]


x <- list(1:3, 'Hello Python')
x <- th.list(x)
str(x)
is.list(x)
pySet("a", th.tuple(x))
newTuple <- pyGet0("a")
newTuple[0]
newTuple[1]

y <- PythonInR:::PythonInR_Tuple$new("a", NULL, "tuple")
y[0]
y[1]

pySet("b", th.tuple(1:3))
pyExecp("type(b)")

x <- list(1, 2, LETTERS)
is.vector(x)
comment(x) <- "comment"
is.vector(x)

th.tuple
typehints:::tyhi
typehints:::typehint

PythonInR:::pySetSimple
pySet
PythonInR:::pyVariableExists

pyConnectionCheck <- PythonInR:::pyConnectionCheck

pyTuple <- function(key, value, regFinalizer = FALSE){
    if ( pyConnectionCheck() ) return(invisible(NULL))
    check_string(key)

    if (!missing(value)){
        if ( !(is.vector(value) | is.list(value)) ) 
        	stop("'value' has to be a vector or list")
        comment(value) <- "tuple"
        pySet(key, value)     
    }
    
    if (!pyVariableExists(key))
        stop(sprintf("'%s' does not exist in the global namespace", key))
    vIsTuple <- pyGet(sprintf("isinstance(%s, tuple)", key))
    if (!vIsTuple)
        stop(sprintf("'%s' is not an instance of tuple", key))

    if (regFinalizer){
        py_tuple <- PythonInR_Tuple$new(key, NULL, "tuple")
    }else{
        py_tuple <- PythonInR_TupleNoFinalizer$new(key, NULL, "tuple")
        class(py_tuple) <- class(py_tuple)[-2]
    }
    return(py_tuple)
}