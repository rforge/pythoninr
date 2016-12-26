red <- function(x) sprintf("\033[31m\033[1m%s\033[22m\033[0m", x)
magenta <- function(x) sprintf("\033[35m\033[1m%s\033[22m\033[0m", x)
cyan <-  function(x) sprintf("\033[36m\033[1m%s\033[22m\033[0m", x)
yellow <- function(x) sprintf("\033[33m\033[1m%s\033[22m\033[39m", x)

blue <- function(x) sprintf("\033[34m\033[1m%s\033[22m\033[39m", x)
green <- function(x) sprintf("\033[32m\033[1m%s\033[22m\033[39m", x)

error <- function(message) {
    cat(sprintf("%s %s\n", red("ERROR"), message))
}

warn <- function(message) {
    cat(sprintf("%s %s\n", magenta("WARNING"), message))
}

note <- function(message) {
    cat(sprintf("%s %s\n", cyan("NOTE"), message))
}

info <- function(message) {
    cat(sprintf("%s %s\n", yellow("INFO"), message))
}

## level 1 ... error
## level 2 ... warning
## level 3 ... note
## level 4 ... info
check <- function(domain, condition, level=1, message="", call=sys.call(-1L)) {
    if ( condition ) return(invisible(NULL))
    msg <- sprintf("in %s", domain)
    if ( all(nchar(message) > 0) ) msg <- sprintf("%s\n\t%s", msg, message)
    if ( level == 1 ) error(msg)
    if ( level == 2 ) warn(msg)
    if ( level == 3 ) note(msg)
    if ( level == 4 ) info(msg)
    return(invisible(NULL))
}


equal <- function(x, y, ...) UseMethod("equal")

equal.NULL <- function(x, y, ...) {
    return( is.null(x) & is.null(y) )
}

equal.logical <- function(x, y, ...) {
    if (length(class(x)) != length(class(y))) return(FALSE)
    if ( any(class(x) != class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    if ( any(is.finite(x) != is.finite(y)) ) return(FALSE)
    if ( any(x != y) ) return(FALSE)
    return(TRUE)
}

equal.integer <- function(x, y, ...) {
    if (length(class(x)) != length(class(y))) return(FALSE)
    if ( any(class(x) != class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    if ( any(is.finite(x) != is.finite(y)) ) return(FALSE)
    if ( any(x != y) ) return(FALSE)
    return(TRUE)
}

equal.numeric <- function(x, y, ...) {
    args <- list(...)
    if ( is.null(args$tol) ) args$tol <- 1e-5
    if ( all(x == y) ) return(TRUE)
    if (length(class(x)) != length(class(y))) return(FALSE)
    if ( any(class(x) != class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    if ( any(is.finite(x) != is.finite(y)) ) return(FALSE)
    if ( any( abs(x - y) > args$tol ) ) return(FALSE)
    return(TRUE)
}

equal.character <- function(x, y, ...) {
    if (length(class(x)) != length(class(y))) return(FALSE)
    if ( any(class(x) != class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    if ( any(is.finite(x) != is.finite(y)) ) return(FALSE)
    if ( any(x != y) ) return(FALSE)
    return(TRUE)
}

equal.list <- function(x, y, ...) {
    if ( !equal(class(x), class(y)) ) return(FALSE)
    if (length(x) != length(y)) return(FALSE)
    for (i in seq_along(x)) {
        if ( !equal(x[[i]], y[[i]]) ) return(FALSE)
    }
    return(TRUE)
}

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

expect_equal <- function(domain, x, y) {
    check(domain, equal(x, y))
}
