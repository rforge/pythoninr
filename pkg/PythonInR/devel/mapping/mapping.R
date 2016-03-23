mapping <- list()
ip1 <- function() length(mapping) + 1

## R, Python
## vector: length == 1
mapping[[ip1()]] <- list("NULL", "None")
mapping[[ip1()]] <- list("logical", "boolean")
mapping[[ip1()]] <- list("integer", c("int", "long"))
mapping[[ip1()]] <- list("numeric", "float")
mapping[[ip1()]] <- list("character", c("string", "bytes", "unicode"))

## vector: length != 1
## the types are the same as before and saved in the member dtype
## TODO: add the member typehint so it is really 1:1 and not 1:n
##       or actually I only have to add it to the toR methods
mapping[[ip1()]] <- list("vector", c("list", "tuple", "vector", "ndarray"))

## matrix
mapping[[ip1()]] <- list("matrix", c("list", "dict", "matrix", "ndarray")) ## and all the sparse matrices

## array
mapping[[ip1()]] <- list("array", c("list", "dict", "matrix", "ndarray", ""))

## sparse matrix (currently only slam since easy transform able)

## list

## named list

## generators


    
## date

## table <=> array or counter ???
class(unclass(table(3)))











