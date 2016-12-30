if (FALSE) {
    q("no")
    Rdevel
}

library(PythonInR)
library(testthat)

## ---------------------------
## Data Frame (TODO: columns order changes)
## ---------------------------
cars <- head(cars)
pySet("x", cars)
expect_equal(pyType("x"), "PythonInR.data_frame")
expect_equal(c(typeof(pyGet("x")), class(pyGet("x"))), c(typeof(cars), class(cars)))
expect_equal(pyGet("x"), cars)

pySet("x", th.pandas(cars))
expect_equal(pyType("x"), "DataFrame")
expect_equal(c(typeof(pyGet("x")), class(pyGet("x"))), c(typeof(cars), class(cars)))
expect_equal(pyGet("x"), cars)

## 
## 
## head(cars)
## 
## z <- pyGet("x")
## z$speed
## 
## 
## pyExecp("x[0:5]")
## z <- pyGet("x")
## head(cars)
## head(z)
## head(as.data.frame(z$data, row.names=z$rownames, col.names=z$colnames))
## head(as.data.frame(z$data, row.names=z$rownames, col.names=c("dist", "speed")))
## 
## z$data$dist[1:3]
## 
## 
## 
## pySet("x", cars)
## pyExecp("x[0:5]")
## pyExecp("y = x.to_pandas()")
## 
## pyExecp("x.shape")
## pyExecp("x.to_dict()")
## 
## 
## BEGIN.Python()
## x.dict()
## 
## list(x.index)
## 
## def pandas_data_frame_to_dict(x):
##     return __R__.data_frame(x.to_dict(), rownames=list(x.index), dim=x.shape)
## 
## pandas_data_frame_to_dict(x).rownames
## 
## END.Python
## 
## pyExecp("y = x.to_r()")
## pyExecp("y['data']")
## pyExecp("y['rownames']")
## 
## pyExecp("import pandas as pd")
## pyExecp("pd.DataFrame({'a' : [1, 0, 1], 'b' : [0, 1, 1] }, dtype=int)")
## 
## pyExec("
## for k in x.keys():
##     x[k] = list(x[k])
## ")
## pyExecp("x['speed']")
## pyExecp("dir(x)")
## pyExecp("x.rownames = None")
## pyExecp("df = pd.DataFrame(data=x, index=list(x.rownames))")
## pyExecp("df[0:5]")
## 
## z <- pyGet("y")
## z$data
## 
## ca <- cars
## rownames(ca) <- NULL
## pySet("x", ca)
## pyExecp("x.rownames")
## pyExecp("x.dim[0]")
## 
## 
## for (i in 1:10000) {
##     print(i)
##     pySet("x", cars)
##     pyPrint("x")
##     pyPrint("x['speed']")
## }
## 
## for (i in 1:10000) {
##     print(i)
##     pySet("x", th.pandas(cars))
##     ##pyPrint("x[0:5]")
##     ##pyPrint("x['speed']")
## }
## 
## pyExecp("x.to_pandas()[0:5]")
## 
## pyGet("")
## 
## 
## for (i in 1:10000) {
##     pySet("x", cars)    
## }
## 
## for (i in 1:10000) {
##     pyGet("x")
## }
## 
## class(pyGet("x"))
## 
## pyExecp("dict(x)")
## pyExecp("x['speed']")
## pyExecp("x['dist']")
## pyGet("x['dist']")
## z <- pyGet("x")
## class(z)
## str(z)
## str(cars)
## 
## 
## 
## 
## pySet("x", th.int(Mi))
## expect_equal(pyType("x"), "PythonInR.matrix")
## expect_true(pyGet("x.dtype is int"))
## expect_equal(typeof(pyGet("x")), typeof(Mi))
## expect_equal(pyGet("x"), Mi)
## 
## 
## 
## expect_equal(pyType("x"), "PythonInR.data_frame")
## expect_equal(typeof(pyGet("x")), typeof(Mi))
## expect_equal(pyGet("x"), Mi)
## 
## BEGIN.Python()
## import pandas as pd
## dir(pd)
## pd.DataFrame(x)[1:4]
## 
## dict(x)
## dir(dict(x))
## [list(v) for v in x.values()]
## for k in x.keys():
##     print(k)
##     x[k] = list(x[k])
## 
## END.Python
## 
## 
## args(data.frame)
## as.data.frame
## 
## y <- as.list(cars)
## y <- unname(y)
## str(as.data.frame(y, col.names=c("a", "b")))
## 
## x <- y
## 
## f = function(x) {
##     if ('colnames' %in% names(x)) {
##        return( base::as.data.frame(x$data, x$rownames, col.names=x$colnames, stringsAsFactors=FALSE) )
##     }
##     return( base::as.data.frame(x$data, x$rownames, stringsAsFactors=FALSE) )
## }
