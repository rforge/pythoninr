if (FALSE) {
    q("no")
    Rdevel
}

library(PythonInR)
library(testthat)

## compare type
cty <- function(x, y) {
    expect_equal(class(x), class(y))
    attributes(x) <- NULL
    attributes(y) <- NULL
    expect_equal(x, y)
}

context("NULL")
x <- NULL
pySet("x", x)
cty(pyGet("str(x)"), "None")
cty(pyGet("x"), x)

context("TRUE")
x <- TRUE
pySet("x", x)
cty(pyGet("str(x)"), "True")
expect_that(pyGet("x"), equals(x))

context("Long")
x <- 1L
pySet("x", x)
cty(pyGet("type(x).__name__"), "long")
cty(pyGet("x"), x)

context("Int")
x <- th.int(1L)
pySet("x", x)
cty(pyGet("type(x).__name__"), "int")
cty(pyGet("x"), x)

## todo change the name in the docs to float
context("float")
x <- 1
pySet("x", x)
cty(pyGet("type(x).__name__"), "float")
cty(pyGet("x"), x)

context("string")
x <- th.string("R")
pySet("x", x)
cty(pyGet("type(x).__name__"), "str")
cty(pyGet("x"), x)

context("unicode")
x <- "R"
pySet("x", x)
cty(pyGet("type(x).__name__"), "unicode")
cty(pyGet("x"), x)

## Vectors of length 0 (TODO: does currently not work as intended!)
context("vector - length==0 - boolean")
x <- logical()
pySet("x", x)

## Vectors of length > 1
pyExecp("x")

