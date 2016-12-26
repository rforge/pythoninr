#' # pyOptions
require(testthat)
require(PythonInR)
invisible(capture.output(pyConnect()))

## PySource
tmpfile <- tempfile(fileext=".R")
writeLines(c("x <- 3", "print(x)", "BEGIN.Python()", 
             "x=3**3", "print(u'Hello R!\\n')", 
             "END.Python"), tmpfile)
expect_that(pySource(tmpfile), prints_text("Hello R!"))
