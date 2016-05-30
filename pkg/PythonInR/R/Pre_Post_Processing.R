## ---------------------------------------------------------
## add addtional function for pre-transformations
## ---------------------------------------------------------
r_to_py_preprocessing <- new.env()
r_to_py_preprocessing[["array"]] <- function(x) {
    aperm(x, rev(seq_len(length(dim(x)))))
}

py_to_r_postprocessing <- new.env()
py_to_r_postprocessing[["vector"]] <- function(x) {
    ## TODO: add dtype 
    if ( is.null(x$names) ) return(x$values)
    if ( length(x$names) == length(x$values) ) return(setNames(x$values, x$names))
    return(x$values)
}

py_to_r_postprocessing[["matrix"]] <- function(x) {
    M <- do.call(rbind, x$values)
    if ( ncol(M) == length(x$colnames) ) colnames(M) <- x$colnames 
    if ( nrow(M) == length(x$rownames) ) rownames(M) <- x$rownames
    M
}

py_to_r_postprocessing[["array"]] <- function(x) {
    xdim <- x$dim
    x <- array(x$data, rev(x$dim))
    return(aperm(x, rev(seq_len(length(xdim)))))
}

py_to_r_postprocessing[["data.frame"]] <- function(x) {
    xcolnames <- x$colnames
    xrownames <- x$rownames
    x <- as.data.frame(x$data.frame)
    if ( ncol(x) == length(xcolnames) ) colnames(M) <- xcolnames 
    if ( nrow(x) == length(xrownames) ) rownames(M) <- xrownames
    x
}

py_to_r_postprocessing[['Tree']] <- function(x) {
    fun <- function(x) {
        x <- x[c('value', 'children')]
        class(x) <- "Tree"
        return(x)
    }
    x <- x[c('value', 'children')]
    x[['children']] <- Tree_apply(x, fun)
    class(x) <- "Tree"
    return(x)
}

py_to_r_postprocessing[["simple_triplet_matrix"]] <- function(x) {
    tryCatch({simple_triplet_matrix(x$i, x$j, x$j, x$nrow, x$ncol, x$dimnames)},
              error = function(e) x)
}

py_to_r_postprocessing[["error"]] <- function(x) {
    structure(x, class=c("error", "PythonInR") )
}



##        return( {"values": self.values, "rownames": self.rownames, 
##                "colnames": self.colnames, "dim": self.dim, "dtype": self.dtype} )
