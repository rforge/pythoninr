th.int <- function(x) tyhi(x, "int")
th.long <- function(x) tyhi(x, "long")
th.float <- function(x) tyhi(x, "float")
th.complex <- function(x) tyhi(x, "complex")

th.string <- function(x) tyhi(x, "string")
th.bytes <- function(x) tyhi(x, "bytes")
th.unicode <- function(x) tyhi(x, "unicode")

th.vector <- function(x) tyhi(x, "vector")
th.vector_int <- function(x) tyhi(x, c("vector", "int"))
th.vector_str <- function(x) tyhi(x, c("vector", "string"))

th.list      <- function(x) tyhi(x, "list")
th.list_int  <- function(x) tyhi(x, c("list", "int"))
th.list_str  <- function(x) tyhi(x, c("list", "string"))

th.tuple     <- function(x) tyhi(x, "tuple")
th.tuple_int <- function(x) tyhi(x, c("tuple", "int"))
th.tuple_str <- function(x) tyhi(x, c("tuple", "string"))

th.tlist     <- function(x) tyhi(x, "tlist")
th.tlist_str <- function(x) tyhi(x, c("tlist", "int"))
th.tlist_int <- function(x) tyhi(x, c("tlist", "string"))

th.numpy     <- function(x) tyhi(x, "numpy")
th.numpy_int <- function(x) tyhi(x, c("numpy", "int"))
th.numpy_str <- function(x) tyhi(x, c("numpy", "string"))

th.scibsr <- function(x) tyhi(x, "scibsr")
th.scicoo <- function(x) tyhi(x, "scicoo")
th.scicsc <- function(x) tyhi(x, "scicsc")
th.scicsr <- function(x) tyhi(x, "scicsr")
th.scidia <- function(x) tyhi(x, "scidia")
th.scidok <- function(x) tyhi(x, "scidok")
th.scilil <- function(x) tyhi(x, "scilil")
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

th.pandas <- function(x) tyhi(x, "pandas")
