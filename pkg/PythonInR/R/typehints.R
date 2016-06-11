
##  @usage 
##  th.int(x)        ## comment(x) <- "int"
##  th.long(x)       ## comment(x) <- "long"
##  th.float(x)      ## comment(x) <- "float"
##  th.string(x)     ## comment(x) <- "string"
##  th.unicode(x)    ## comment(x) <- "unicode"
##  th.vector(x)     ## comment(x) <- "vector"
##  th.vector_int(x) ## comment(x) <- c("vector", "int")
##  th.vector_str(x) ## comment(x) <- c("vector", "string")
##  th.list(x)       ## comment(x) <- "list"
##  th.list_int(x)   ## comment(x) <- c("list", "int")
##  th.list_str(x)   ## comment(x) <- c("list", "str")
##  th.tlist(x)      ## comment(x) <- "tlist"
##  th.tlist_int(x)  ## comment(x) <- c("tlist", "int")
##  th.tlist_str(x)  ## comment(x) <- c("tlist", "str")
##  th.tuple(x)      ## comment(x) <- "tuple"
##  th.tuple_int(x)  ## comment(x) <- ""
##  th.tuple_str(x)  ## comment(x) <- ""
##  th.ttuple(x)     ## comment(x) <- "ttuple"
##  th.ttuple_int(x) ## comment(x) <- ""
##  th.ttuple_str(x) ## comment(x) <- ""
##  th.numpy(x)      ## comment(x) <- "numpy"
##  th.numpy_int(x)  ## comment(x) <- ""
##  th.numpy_str(x)  ## comment(x) <- ""
##  th.scibsr(x)     ## comment(x) <- "scibsr"
##  th.scicoo(x)     ## comment(x) <- "scicoo"
##  th.scicsc(x)     ## comment(x) <- ""
##  th.scicsr(x)     ## comment(x) <- ""
##  th.scidia(x)     ## comment(x) <- ""
##  th.scidok(x)     ## comment(x) <- ""
##  th.scilil(x)     ## comment(x) <- ""
##  th.cvxopt(x)     ## comment(x) <- ""
##  th.pandas(x)     ## comment(x) <- ""


##  -----------------------------------------------------------
##  typehint
##  ========
##' @title Additional Type Information
##' @description 
##'   The function \code{typehint} allows to set / get additional type information 
##'   in a structured way. Similar to \code{as..*} (e.g. \code{as.list}) 
##'   \pkg{PythonInR} provides \code{th..*} (e.g. \code{th.list}) functions to 
##'   control the type conversion done by \pkg{PythonInR}.
##' @param x an R object
##' @aliases 
##' th.int th.long th.long th.float th.string th.unicode th.vector th.vector_int
##' @details 
##'    Since typehints are implemented as comments one can use the comment
##'    command directly to avoid copying.
##' @examples
##' \dontshow{PythonInR:::pyCranConnect()}
##' pySet("vec", 1:3) ## v will be assigned as PythonInR.vector
##' pyType("vec")
##' ## li will be assigned as list, where the elements are of type long
##' pySet("li", th.list(1:3)) 
##' pyType("li")
##' pySet("li_int", th.list_int(1:3)) 
##' pyType("li_int")
##' pySet("x", th.tuple(list(1, 2))) ## x will be assigned as tuple
##' pyType("x")
##' @name typehint
##' @rdname typehint
##  -----------------------------------------------------------
NULL

typehint <- function(x) comment(x)

`typehint<-` <- function(x, value) {
    comment(x) <- value
    x
}

##  -----------------------------------------------------------
##  tyhi
##  ====
##  @title Additional Type Information
##  @description The function \code{tyhi} allows to set / get
##               additional type information in a structured way.
##  @param x
##  @examples
##  x <- list(1, 2)
##  tyhi(x, "tuple")
##  tyhi(x)
##  -----------------------------------------------------------
tyhi <- function(x, hint) {
    if ( missing(hint) ) return( typehint(x) )
    if ( is.character(hint) ) {
        typehint(x) <- hint
    }
    x
}

##' @name th.int
##' @rdname typehint
th.int <- function(x) tyhi(x, "int")

##' @name th.long
##' @rdname typehint
th.long <- function(x) tyhi(x, "long")

##' @name th.float
##' @rdname typehint
th.float <- function(x) tyhi(x, "float")

## th.complex <- function(x) tyhi(x, "complex")

##' @name th.string
##' @rdname typehint
th.string <- function(x) tyhi(x, "string")
## th.bytes <- function(x) tyhi(x, "bytes")

##' @name th.unicode
##' @rdname typehint
th.unicode <- function(x) tyhi(x, "unicode")

##' @name th.vector
##' @rdname typehint
th.vector <- function(x) tyhi(x, "vector")

##' @name th.vector_int
##' @rdname typehint
th.vector_int <- function(x) tyhi(x, c("vector", "int"))

##' @name th.vector_str
##' @rdname typehint
th.vector_str <- function(x) tyhi(x, c("vector", "string"))

##' @name th.list
##' @rdname typehint
th.list      <- function(x) tyhi(x, "list")

##' @name th.list_int
##' @rdname typehint
th.list_int  <- function(x) tyhi(x, c("list", "int"))

##' @name th.list_str
##' @rdname typehint
th.list_str  <- function(x) tyhi(x, c("list", "string"))

##' @name th.tuple
##' @rdname typehint
th.tuple     <- function(x) tyhi(x, "tuple")

##' @name th.tuple_int
##' @rdname typehint
th.tuple_int <- function(x) tyhi(x, c("tuple", "int"))

##' @name th.tuple_str
##' @rdname typehint
th.tuple_str <- function(x) tyhi(x, c("tuple", "string"))

##' @name th.ttuple
##' @rdname typehint
th.ttuple     <- function(x) tyhi(x, "ttuple")

##' @name th.ttuple_int
##' @rdname typehint
th.ttuple_int <- function(x) tyhi(x, c("ttuple", "int"))

##' @name th.ttuple_str
##' @rdname typehint
th.ttuple_str <- function(x) tyhi(x, c("ttuple", "string"))

##' @name th.tlist ## comment(x) <- "tlist"
##' @rdname typehint
th.tlist     <- function(x) tyhi(x, "tlist")

##' @name th.tlist_str
##' @rdname typehint
th.tlist_str <- function(x) tyhi(x, c("tlist", "int"))

##' @name th.tlist_int
##' @rdname typehint
th.tlist_int <- function(x) tyhi(x, c("tlist", "string"))

##' @name th.numpy
##' @rdname typehint
th.numpy     <- function(x) tyhi(x, "numpy")

##' @name th.numpy_int
##' @rdname typehint
th.numpy_int <- function(x) tyhi(x, c("numpy", "int"))

##' @name th.numpy_str
##' @rdname typehint
th.numpy_str <- function(x) tyhi(x, c("numpy", "string"))

##' @name th.scibsr
##' @rdname typehint
th.scibsr <- function(x) tyhi(x, "scibsr")

##' @name th.scicoo
##' @rdname typehint
th.scicoo <- function(x) tyhi(x, "scicoo")

##' @name th.scicsc
##' @rdname typehint
th.scicsc <- function(x) tyhi(x, "scicsc")

##' @name th.scicsr
##' @rdname typehint
th.scicsr <- function(x) tyhi(x, "scicsr")

##' @name th.scidia
##' @rdname typehint
th.scidia <- function(x) tyhi(x, "scidia")

##' @name th.scidok
##' @rdname typehint
th.scidok <- function(x) tyhi(x, "scidok")

##' @name th.scilil
##' @rdname typehint
th.scilil <- function(x) tyhi(x, "scilil")

##' @name th.cvxopt
##' @rdname typehint
th.cvxopt <- function(x) {
	if ( is.matrix(x) & is.numeric(x) ) {
		if (is.integer(x)) return(tyhi(x, c("cvxopt", "int")))
		return(tyhi(x, "cvxopt"))
	}		
	if ( is.simple_triplet_matrix(x) ) {
		if ( is.numeric(x$v) ) {
			if (is.integer(x)) return(tyhi(x, c("cvxopt", "int")))
			return(tyhi(x, "cvxopt"))
		}
	}
	stop("TYPE_ERROR in 'th.cvxopt': cvxopt matrices have to be of type 'numeric'!")
}

##' @name th.pandas
##' @rdname typehint
th.pandas <- function(x) tyhi(x, "pandas")
