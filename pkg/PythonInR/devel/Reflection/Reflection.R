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


