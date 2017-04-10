if (FALSE) {
    q("no")
    Rdevel
}

library(PythonInR)
library(NLP)
library(testthat)

vp <- Tree('VP', list(Tree('V', list('saw')), Tree('NP', list('him'))))
## pySet("x", vp)
## 
## pyExecp("x")
## pyExecp("type(x)")
## pyExecp("x.to_r()")
## 
## str(vp)
##
## TODO!
##
##if ( isTRUE(pyGet("__R__.PythonInR_FLAGS")[["useNltkTree"]]) ) {
##	expect_equal(pyType("x"), c("Tree"))
##	expect_equal(pyGet("x"), vp)
##} else {
##	## pyExecp("__R__.PythonInR_FLAGS['useNltkTree'] = False")
##	#TODO:# expect_equal(pyType("x"), c("PythonInR.Tree"))
##	#TODO:# expect_equal(pyGet("x"), vp)
##}
