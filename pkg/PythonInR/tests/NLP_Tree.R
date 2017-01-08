if (FALSE) {
    q("no")
    Rdevel
}

library(PythonInR)
library(NLP)
library(testthat)

vp <- Tree('VP', list(Tree('V', list('saw')), Tree('NP', list('him'))))
pySet("x", vp)
expect_true(pyType("x") %in% c("Tree", "PythonInR.Tree"))
expect_equal(pyGet("x"), vp)

