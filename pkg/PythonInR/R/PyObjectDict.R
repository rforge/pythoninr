##  
##  pyDict
##
##
##  PythonInR_Dict
##      class definition

PythonInR_Dict <-
  R6Class(
    "PythonInR_Dict",
    portable = TRUE,
    inherit = PythonInR_Object,
    public = list(
      print = function() pyExecp(self$.name),
      clear = function(){
          cable <- sprintf("%s.clear", self$.name)
          pyCall(cable)},
      copy = function(){
          cable <- sprintf("%s.copy", self$.name)
          pyCall(cable)},
      fromkeys = function(seq, value){
          cable <- sprintf("%s.fromkeys", self$.name)
          if (missing(value)) pyCall(cable, list(seq))
          else pyCall(cable, list(seq, value))},
      get = function(key, default){
          cable <- sprintf("%s.get", self$.name)
          if (missing(value)) pyCall(cable, list(key))
          else pyCall(cable, list(key, default))},
      has_key = function(key){
          cable <- sprintf("%s.has_key", self$.name)
          pyCall(cable, list(key))},
      items = function(){
          cable <- sprintf("%s.items", self$.name)
          pyCall(cable)},
      keys = function(key){
          cable <- sprintf("%s.keys", self$.name)
          pyCall(cable)},
      pop = function(key, default){
          cable <- sprintf("%s.pop", self$.name)
          if (missing(value)) pyCall(cable, list(key))
          else pyCall(cable, list(key, default))},
      popitem = function(){
          cable <- sprintf("%s.popitem", self$.name)
          pyCall(cable)},
      setdefault = function(key, default){
          cable <- sprintf("%s.setdefault", self$.name)
          if (missing(value)) pyCall(cable, list(key))
          else pyCall(cable, list(key, default))},
      update = function(dict){
          cable <- sprintf("%s.update", self$.name)
          pyCall(cable, list(dict))},
      values = function(){
          cable <- sprintf("%s.values", self$.name)
          pyCall(cable)},
      viewitems = function(){
          cable <- sprintf("%s.viewitems", self$.name)
          pyCall(cable)},
      viewkeys = function(){
          cable <- sprintf("%s.viewkeys", self$.name)
          pyCall(cable)},
      viewvalues = function(){
          cable <- sprintf("%s.viewvalues", self$.name)
          pyCall(cable)}
    ))

PythonInR_DictNoFinalizer <-
    R6Class("PythonInR_Dict",
            portable = TRUE,
            inherit = PythonInR_Dict,
            public = list(
                initialize = function(variableName, objectName, type) {
                    if (!missing(variableName)) self$.name <- variableName
                    if (!missing(objectName)) self$.objname <- objectName
                    if (!missing(type)) self$.type <- type
                }
            ))

`[.PythonInR_Dict` <- function(x, i){
    slice <- deparse(i)
    pyGet(sprintf("%s[%s]", x$.name, slice))
}

`[<-.PythonInR_Dict` <- function(x, i, value){
    if (length(i) > 1) class(i) <- "tuple"
    success <- .Call("r_set_py_dict", x$.name, i, value)
    x
}

#  ---------------------------------------------------------
#  pyDict
#  ======
#' @title Create a virtual Python dictionary
#'
#' @description The function pyDict creates a virtual Python object 
#'              of type PythonInR_Dict.
#' @param key a character string giving the name of the Python object.
#' @param value if a value is provided, a new Python dictionary is created based 
#'              on the value. Therefore allowed values of value are named lists and 
#'              names vectors.
#' @param regFinalizer a logical indicating if a finalizer should be
#'                     be registered, the default value is TRUE.
#' @details If no value is provided a virtual Python dict for an existing
#'          Python object is created. If the value is NULL, an empty 
#'          virtual Python object for an empty dict is created.
#'          If the value is a named vector or named list, a new Python
#'          object based on the vector or list is created.
#' @examples
#' \dontshow{PythonInR:::pyCranConnect()}
#' if ( pyIsConnected() ){
#' pyExec('myPyDict = {"a":1, "b":2, "c":3}')
#' ## create a virtual Python dictionary for an existing dictionary
#' myDict <- pyDict("myPyDict")
#' myDict["a"]
#' myDict["a"] <- "set the key"
#' myDict
#' ## allowed keys are
#' myDict['string'] <- 1
#' myDict[3L] <- "long"
#' myDict[5] <- "float"
#' myDict[th.tuple(c("t", "u", "p", "l", "e"))] <- "tuple"
#' myDict
#' ## NOTE: Python does not make a difference between a float key 3 and a long key 3L
#' myDict[3] <- "float"
#' myDict
#' ## create a new Python dict and virtual dict
#' myNewDict <- pyDict('myNewDict', list(p=2, y=9, r=1))
#' myNewDict
#' }
#  ---------------------------------------------------------
pyDict <- function(key, value, regFinalizer = TRUE){
    if ( pyConnectionCheck() ) return(invisible(NULL))
    check_string(key)

    if (!missing(value)){
        ## create a new object
        if (is.null(value)){
          pyExec(sprintf("%s = dict()", key))
        }else{
          pySetSimple(key, value)
        }
    }

    if (!pyVariableExists(key))
        stop(sprintf("'%s' does not exist in the global namespace",
             key))
    vIsDict <- pyGet(sprintf("isinstance(%s, dict)", key))
    if (!vIsDict)
        stop(sprintf("'%s' is not an instance of dict", key))

    if (regFinalizer){
      py_dict <- PythonInR_Dict$new(key, NULL, "dict")
    }else{
      py_dict <- PythonInR_DictNoFinalizer$new(key, NULL, "dict")
    }
    return(py_dict)
}


#  ---------------------------------------------------------
#  pyDictZip
#  =========
#' @title Create a dictionary
#'
#' @description The function pyDictZip creates a dictionary based on a
#'              list of keys and a list of values.
#' @param keys a list giving the keys of the Python object.
#' @param values a list giving the values of the Python object.
#' @param regFinalizer a logical indicating if a finalizer should be
#'                     be registered, the default value is TRUE.
#' @details If no value is provided a virtual Python dict for an existing
#'          Python object is created. If the value is NULL, an empty 
#'          virtual Python object for an empty dict is created.
#'          If the value is a named vector or named list, a new Python
#'          object based on the vector or list is created.
#' @examples
#' \dontshow{PythonInR:::pyCranConnect()}
#' if ( pyIsConnected() ) {
#' pyDictZip(th.string(LETTERS[1:3]), 1:3)
#' }
pyDictZip <- function(keys, values, regFinalizer=TRUE) {
    x <- pyCall('__R__.pyDictZip', list(keys, values), autoTypecast = FALSE)
    return(pyDict(pyRef(x)))
}

