if (FALSE) {
    q("no")
    Rdevel
    ## Rdevel --debugger=gdb
    ## run
}

library(PythonInR)
library(testthat)

is_pandas_installed <- pyGet("__R__.PythonInR_FLAGS['usePandas']")


## ---------------------------
## Data Frame
## ---------------------------
n <- 1L ## 10000L
for (i in seq_len(n)) {
    cars <- head(cars)
    pySet("x", cars)
    expect_equal(pyType("x"), "PythonInR.data_frame")
    expect_equal(c(typeof(pyGet("x")), class(pyGet("x"))), c(typeof(cars), class(cars)))
    expect_equal(pyGet("x"), cars)

if ( is_pandas_installed ) {
    pySet("x", th.pandas(cars))
    expect_equal(pyType("x"), "DataFrame")
    expect_equal(c(typeof(pyGet("x")), class(pyGet("x"))), c(typeof(cars), class(cars)))
    expect_equal(pyGet("x"), cars)
}

    df <- data.frame(id=seq_along(LETTERS), LETTERS)

    pySet("x", df)
    expect_equal(pyType("x"), "PythonInR.data_frame")
    expect_equal(c(typeof(pyGet("x")), class(pyGet("x"))), c(typeof(cars), class(cars)))
    x <- pyGet("x")

    expect_equal(colnames(x), colnames(df))
    expect_equal(x[,1], df[,1])
    expect_equal(x[,2], as.character(df[,2]))

if ( is_pandas_installed ) {
    pySet("x", th.pandas(df))
    expect_equal(pyType("x"), "DataFrame")
    x <- pyGet("x")
    expect_equal(colnames(x), colnames(df))
    expect_equal(x[,1], df[,1])
    expect_equal(x[,2], as.character(df[,2]))
}

    ## empty data frame
    df <- data.frame()
    pySet("x", df)
    z <- pyGet("x")
    expect_equal(class(z), class(df))
    expect_equal(dim(z), dim(df))

if ( is_pandas_installed ) {
    pySet("x", th.pandas(df))
    expect_equal( pyType("x"), "DataFrame" )
    z <- pyGet("x")
    expect_equal(class(z), class(df))
    expect_equal(dim(z), dim(df))
}

    df <- data.frame(x=character(), y=integer(), stringsAsFactors=FALSE)
    pySet("x", df)
    z <- pyGet("x")
    expect_equal(class(z), class(df))
    expect_equal(z, df)

if ( is_pandas_installed ) {
    pySet("x", th.pandas(df))
    z <- pyGet("x")
    unclass(z)
    expect_equal(class(z), class(df))
    expect_equal(dim(z), dim(df))
}

}

