if (FALSE) {
    q("no")
    Rdevel  
}

library(PythonInR)
library(testthat)

buildAscii <- function(len, clen=100){
    fun <- function(x) paste(rawToChar(as.raw(sample(33:126, clen, replace=TRUE)), multiple=TRUE), collapse="")
    sapply(1:len, fun)
}

for (i in 1:1000) {
    pySet("x", NULL)
    pyGet("x")
}

for (i in 1:1000) {
    pySet("x", TRUE)
    pyGet("x")
}

for (i in 1:1000) {
    pySet("x", 1L)
    pyGet("x")
}

for (i in 1:1000) {
    pySet("x", 1)
    pyGet("x")
}

for (i in 1:10000) {
    pySet("x", "Hällö Wörld")
    pyGet("x")
}

for (i in 1:10000) {
    pySet("x", "Hällö Wörld")
    pyGet("x")
}

for (i in 1:10000) {
    pySet("x", list(a=3, b=4, c=5))
    pyGet("x")
}

x <- as.logical(sample(c(0,1), 1000, replace=TRUE))
for (i in 1:10000) {
    pySet("x", x)
    pyGet("x")
}

x <- sample(1:1000000, 1000)
for (i in 1:10000) {
    pySet("x", x)
    pyGet("x")
}

x <- rnorm(1000) * 1000000
for (i in 1:10000) {
    pySet("x", x)
    pyGet("x")
}

## look at the reference counts for String!!!
x <- buildAscii(1000)
for (i in 1:10000) {
    pySet("x", x)
    pyGet("x")
}

x <- sapply(1:1000, function(x) intToUtf8(sample(1:1000, 1000, replace=TRUE)))
for (i in 1:10000) {
    pySet("x", x)
    pyGet("x")
}



for (i in 1:10000) {
    pySet("x", cars)
    pyGet("x")
}

