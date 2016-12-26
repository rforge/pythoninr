if (FALSE) {
    q("no")
    Rdevel  
}

## This shows that there are still issues with the memory allocation.
## The main problem is, since Python also often doesn'r free memory 
## it is not entirely clear if this is an issue of PythonInR or 
## a genereal Python problem.
n <- 2 ## 10000

library(PythonInR)
library(testthat)

buildAscii <- function(len, clen=100){
    fun <- function(x) paste(rawToChar(as.raw(sample(33:126, clen, replace=TRUE)), multiple=TRUE), collapse="")
    sapply(1:len, fun)
}

for (i in seq_len(n)) {
    pySet("x", NULL)
    pyGet("x")
}

for (i in seq_len(n)) {
    pySet("x", TRUE)
    pyGet("x")
}

for (i in seq_len(n)) {
    pySet("x", 1L)
    pyGet("x")
}

for (i in seq_len(n)) {
    pySet("x", 1)
    pyGet("x")
}

for (i in seq_len(n)) {
    pySet("x", "Hällö Wörld")
    pyGet("x")
}

for (i in seq_len(n)) {
    pySet("x", "Hällö Wörld")
    pyGet("x")
}

for (i in seq_len(n)) {
    pySet("x", list(a=3, b=4, c=5))
    pyGet("x")
}

x <- as.logical(sample(c(0,1), 1000, replace=TRUE))
for (i in seq_len(n)) {
    pySet("x", x)
    pyGet("x")
}

x <- sample(1:1000000, 1000)
for (i in seq_len(n)) {
    pySet("x", x)
    pyGet("x")
}

x <- rnorm(1000) * 1000000
for (i in seq_len(n)) {
    pySet("x", x)
    pyGet("x")
}

## look at the reference counts for String!!!
x <- buildAscii(1000)
for (i in seq_len(n)) {
    pySet("x", x)
    pyGet("x")
}

x <- sapply(1:1000, function(x) intToUtf8(sample(1:1000, 1000, replace=TRUE)))
for (i in seq_len(n)) {
    pySet("x", x)
    pyGet("x")
}

for (i in seq_len(n)) {
    pySet("x", cars)
    pyGet("x")
}

