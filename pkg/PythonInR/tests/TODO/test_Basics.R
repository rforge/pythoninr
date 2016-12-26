library(PythonInR)
source("utility.R")

test_basics <- function() {
    #' ## pyDir
    check("test_basics@001", equal(intersect(pyDir(), "__name__"), "__name__"))
    check("test_basics@002", equal(intersect(pyDir("sys"), "version"), "version"))

    #' ## pyHelp
    check("test_basics@003", any(grepl("built-in function", capture.output(pyHelp("abs")))))

    #' ## pyType
    check("test_basics@004", equal(pyType("dict()"), "dict"))
}

local({test_basics()})


