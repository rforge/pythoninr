
library(PythonInR)

pyExec("import os")

args <- list(c("x", "string"))
callableObj <- "os.call"

definePyFunction <- function(callableObj, ...) {
    args <- list(...)
    arg <- args[[1]]
    code <- sprintf("function(%s) {", arg[1])
    code <- c(code, sprintf("    %s <- th.%s(%s)", arg[1], arg[2], arg[1]))
    code <- c(code, sprintf("    pyCall('%s', args = list(%s))", callableObj, arg[1]))
    code <- c(code, "}")
    eval(parse(text=paste(code, collapse="\n")))
}

fun <- definePyFunction("os.chdir", c("x", "string"))
fun(".")
fun
 

