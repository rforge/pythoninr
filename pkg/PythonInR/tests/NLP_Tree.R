if (FALSE) {
    q("no")
    Rdevel
}

library(PythonInR)
library(NLP)
library(testthat)

vp <- Tree('VP', list(Tree('V', list('saw')), Tree('NP', list('him'))))
pySet("x", vp)
expect_equal(pyType("x"), "Tree")
expect_equal(pyGet("x"), vp)
