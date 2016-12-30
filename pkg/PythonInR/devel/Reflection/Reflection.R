q("no")
Rdevel

library(PythonInR)

## Test 1
## import inspect

pyExec("import os")
pyExecp("os.chdir")

pyExec("import inspect")
pyExecp("os.chdir.__doc__")

## get members
pyExecp("inspect.getmembers(os)")

pyExecp("inspect.getclasstree(os.chdir)")

pyExecp("inspect.getcallargs(os.chdir)")

pyExecp("inspect.getsource(os.chdir)")

pyExecp("dir(os.chdir)")
pyExecp("os.chdir.__str__")
pyExecp("os.chdir.")

pyExecp("inspect.getargvalues(os.chdir)")

## for function
pyExecp("inspect.getargspec()")


BEGIN.Python()

import inspect

def foo(a,b,c=4, *arglist, **keywords): 
	pass

inspect.getargspec(foo)
inspect.getcallargs(foo, 1, 2)

def fun(a, b, c, d):
	pass

inspect.getargspec(fun)

inspect.getsourcelines(os.getcwd) 

inspect.getmembers(type(fun), inspect.isdatadescriptor)
dir(fun.__init__)
fun.__init__.__str__

import dill

dill.source.getsource(fun)

END.Python


callFun <- '
function(..., autoTypecast=pyOptions("autoTypecast"), simplify=pyOptions("simplify")) {
  x <- list(...)
  i <- if ( !is.null(names(x)) ) (nchar(names(x)) > 0) else rep(FALSE, length(x))
  xargs <- if ( sum(!i) > 0 ) x[!i] else NULL
  xkwargs <- if ( sum(i) > 0 ) x[i] else NULL
  return( pyCall("%s", args=xargs, kwargs=xkwargs, 
          autoTypecast=autoTypecast, simplify=simplify) )
}
'

pyFunction <- function(key, regFinalizer = FALSE){
    cfun <- sprintf(callFun, key)
    fun <- eval(parse(text=cfun))
    class(fun) <- c("pyFunction", "PythonInR_Object")
    attr(fun, "name") <- key
    if ( regFinalizer ) {
        funenv <- new.env(parent = emptyenv())
        reg.finalizer(funenv, function(x) pyExec(pyTry(sprintf("del(%s)", key))))
    }
    fun
}

f <- pyFunction("fun")
str(f)




