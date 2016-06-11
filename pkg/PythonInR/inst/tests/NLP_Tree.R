q("no")
Rdevel

library(PythonInR)
library(testthat)
library(NLP)

vp <- Tree('VP', list(Tree('V', list('saw')), Tree('NP', list('him'))))
pySet("x", vp)
expect_equal(pyType("x"), "Tree")
expect_equal(pyGet("x"), vp)

for ( i in seq_len(1e3) ) {
    pySet("x", vp)
    expect_equal(pyType("x"), "Tree")
    expect_equal(pyGet("x"), vp)
}
