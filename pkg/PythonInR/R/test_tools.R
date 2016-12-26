##  -----------------------------------------------------------
##  equal
##  =====
##' @title Compare two Objects
##' @description The utility function \code{equal} can be used to compare two
##'              objects and is mainly used for testing purposes.
##' @param x an \R object to be compared with object y.
##' @param y an \R object to be compared with object x.
##' @param ... optional arguments to \code{equal}.
##' @return \code{TRUE} if \code{x} and \code{y} are equal \code{FALSE} otherwise.
##' @examples
##' ## compare numeric values
##' equal(1e-4, 1e-5, tol=1e-3)
##' @export
#  -----------------------------------------------------------
equal <- function(x, y, ...) UseMethod("equal")

##' @rdname equal
##' @export
equal.NULL <- function(x, y, ...) {
    return( is.null(x) & is.null(y) )
}

##' @rdname equal
##' @export
equal.logical <- function(x, y, ...) {
    if (length(class(x)) != length(class(y))) return(FALSE)
    if ( any(class(x) != class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    if ( any(is.finite(x) != is.finite(y)) ) return(FALSE)
    if ( any(x != y) ) return(FALSE)
    return(TRUE)
}

##' @rdname equal
##' @export
equal.integer <- function(x, y, ...) {
    if (length(class(x)) != length(class(y))) return(FALSE)
    if ( any(class(x) != class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    if ( any(is.finite(x) != is.finite(y)) ) return(FALSE)
    if ( any(x != y) ) return(FALSE)
    return(TRUE)
}

##' @rdname equal
##' @export
equal.numeric <- function(x, y, ...) {
    args <- list(...)
    if ( is.null(args$tol) ) args$tol <- 1e-5
    if (length(class(x)) != length(class(y))) return(FALSE)
    if ( any(class(x) != class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    if ( any(is.finite(x) != is.finite(y)) ) return(FALSE)
    if ( any( abs(x - y) > args$tol ) ) return(FALSE)
    return(TRUE)
}

##' @rdname equal
##' @export
equal.character <- function(x, y, ...) {
    if (length(class(x)) != length(class(y))) return(FALSE)
    if ( any(class(x) != class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    if ( any(is.finite(x) != is.finite(y)) ) return(FALSE)
    if ( any(x != y) ) return(FALSE)
    return(TRUE)
}

##' @rdname equal
##' @export
equal.list <- function(x, y, ...) {
    if ( !equal(class(x), class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    for (i in seq_along(x)) {
        if ( !equal(x[[i]], y[[i]]) ) return(FALSE)
    }
    return(TRUE)
}

##' @rdname equal
##' @export
equal.simple_triplet_matrix <- function(x, y, ...) {
    if ( !equal(class(x), class(y)) ) return(FALSE)
    if ( !equal(x$nrow, y$nrow) ) return(FALSE)
    if ( !equal(x$ncol, y$ncol) ) return(FALSE)
    xo <- order(x$j, x$i)
    yo <- order(y$j, y$i)
    if ( !equal(x$i[xo], y$i[yo]) ) return(FALSE)
    if ( !equal(x$j[xo], y$j[yo]) ) return(FALSE)
    if ( !equal(x$v[xo], y$v[yo]) ) return(FALSE)
    return(TRUE)
}



