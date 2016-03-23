
##  -----------------------------------------------------------
##  typehint
##  ========
##' @title Additional Type Information
##' @description The function \code{typehint} allows to set / get
##'              additional type information in a structured way.
##' @param x
##' @details Note typehint uses the comment field to store the additional
##'          type information. This can be usefull when 
##'          Comments have the addvantage that they are ignored from print, 
##'          toJSON and other functions.
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
    comment(x) <- comment(x)
    x
}

##  -----------------------------------------------------------
##  tyhi
##  ====
##' @title Additional Type Information
##' @description The function \code{typehint} allows to set / get
##'              additional type information in a structured way.
##' @param x
##' @details Note typehint uses the comment field to store the additional
##'          type information. This can be usefull when 
##'          Comments have the addvantage that they are ignored from print, 
##'          toJSON and other functions.
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
##' @title Additional Type Information
##' @description The function \code{typehint} allows to set / get
##'              additional type information in a structured way.
##' @param x
##' @details Note typehint uses the comment field to store the additional
##'          type information. This can be usefull when 
##'          Comments have the addvantage that they are ignored from print, 
##'          toJSON and other functions.
##' @examples
##' x <- list(1, 2)
##' th.tuple <- function(x) tyhi(x, "tuple")
##' th.tuple(x)
##' tyhi(x)
##' @export
##  -----------------------------------------------------------
th <- function(x) UseMethod( "th" )
