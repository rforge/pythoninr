
##  -----------------------------------------------------------
##  typehint
##  ========
##' @title Additional Type Information
##' @description The function \code{typehint} allows to set / get
##'              additional type information in a structured way.
##' @param x
##' @details The typehint package uses the comment field to store additional
##'          type information. This can be useful in cases additional type 
##'          information is needed but the class information and the print 
##'          behavior should remain unchanged. Note it would also be possible 
##'          to use the attributes \dQuote{srcref} or \dQuote{srcfile} but 
##'          utilizing the \dQuote{comment} attribute seems least invasive.
##' @examples
##' x <- list(1, 2)
##' typehint(x) <- "tuple"
##' typehint(x)
##' @export
##  -----------------------------------------------------------
typehint <- function(x) {
    comment(x)
}

##' @noRd
##' @export
`typehint<-` <- function(x, value) {
    comment(x) <- value
    x
}

##  -----------------------------------------------------------
##  tyhi
##  ====
##' @title Additional Type Information
##' @description The function \code{tyhi} allows to set / get
##'              additional type information in a structured way.
##' @param x
##' @examples
##' x <- list(1, 2)
##' tyhi(x, "tuple")
##' tyhi(x)
##' @export
##  -----------------------------------------------------------
tyhi <- function(x, hint) {
    if ( missing(hint) ) return( typehint(x) )
    if ( is.character(hint) ) {
        typehint(x) <- hint
    }
    x
}

##  -----------------------------------------------------------
##  th
##  ==
##  @title Additional Type Information
##  @description The function \code{th} allows to set
##               additional type information in a structured way.
##  @param x
##  @details The following example shows how typehints are used 
##           in the PythonInR package to provide additional type 
##           information.
##  @examples
##  x <- list(1, 2)
##  th.tuple <- function(x) tyhi(x, "tuple")
##  th.tuple(x)
##  tyhi(x)
##  @export
##  -----------------------------------------------------------
##  th <- function(x) UseMethod( "th" )
