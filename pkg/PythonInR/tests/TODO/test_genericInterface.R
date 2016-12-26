
library(PythonInR)

pyExec("import os")

os <- pyGet("os")
grep("dir", ls(os), value=TRUE)

dir()
getwd()
os$chdir("..")

getwd()
os$chdir

class(os$getcwd())
class(os$getcwd(autoTypecast=TRUE))


