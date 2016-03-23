

th.int <- function(x) tyhi(x, "int")
th.long <- function(x) tyhi(x, "long")
th.float <- function(x) tyhi(x, "float")
th.complex <- function(x) tyhi(x, "complex")

th.string <- function(x) tyhi(x, "string")
th.bytes <- function(x) tyhi(x, "bytes")
th.unicode <- function(x) tyhi(x, "unicode")

th.list <- function(x) tyhi(x, "list")
th.tuple <- function(x) tyhi(x, "tuple")
th.tuple_int <- function(x) tyhi(x, c("tuple", "int"))

th.numpy <- function(x) tyhi(x, "numpy")
th.cvxopt <- function(x) tyhi(x, "cvxopt")

th.pandas <- function(x) tyhi(x, "pandas")
