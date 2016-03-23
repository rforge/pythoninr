q("no")

library(typehints)

x <- list(a=1, b=2)
comment(x) <- "tuple"
typehint(x) <- "tuple"
x

library(PythonInR)
ls("package:PythonInR")
x <- 3
y <- th.int(x)
tyhi(y)
PythonInR:::th.int(x)



attributes(x)$tsp <- "tuple"
x

typehint(x)
tyhi(x)
tyhi(th.int(x))

y <- ts(1:10, frequency = 4, start = c(1959, 2))
attributes(y)

as.character(NULL)

class(NULL)

fun <- function(z) {
    check_th("z", "tuple", )
    ##as.character(conditionCall())
    list(sys.frame(), sys.call(), sys.frames(), sys.function(), sys.calls())
}

check_th <- function(x, hint, missing_error = FALSE, env=parent.frame()) {
    typeh <- if ( is.null(typehint(x)) ) "NULL" else typehint(x)
    if ( missing_error ) {
        ok <- typeh %in% c(hint, "name")
    } else {
        ok <- typeh %in% hint
    }
    if (!ok) stop("invalid 'type hint' (", typeh, ") of argument ", x,
                  ", 'type hint' of ", x, " should be (", hint, ")",
                  call. = FALSE)
}

fun()

sum(list())
fun(3)

class(fun(3)[["z"]])
missing
traceback




x <- list(1)
attributes(x)
attributes(x)$srcref <- 3
x
attributes(x)
