th.int <- function(x) tyhi(x, "int")
th.long <- function(x) tyhi(x, "long")
th.float <- function(x) tyhi(x, "float")
th.complex <- function(x) tyhi(x, "complex")

th.string <- function(x) tyhi(x, "string")
th.bytes <- function(x) tyhi(x, "bytes")
th.unicode <- function(x) tyhi(x, "unicode")

th.vector <- function(x) tyhi(x, "vector")

th.list <- function(x) tyhi(x, "list")
th.tuple <- function(x) tyhi(x, "tuple")
th.tuple_int <- function(x) tyhi(x, c("tuple", "int"))

th.numpy <- function(x) tyhi(x, "numpy")
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
	stop("TYPE_ERROR in 'th.cvxopt': cvxopt matrices have to be of type 'double'!")
}

th.pandas <- function(x) tyhi(x, "pandas")
