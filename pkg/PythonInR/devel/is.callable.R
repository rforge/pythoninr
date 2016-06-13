q("no")
Rdevel

library(PythonInR)

PythonInR:::pyIsCallableFt("a")

pyIsCallableFt("a")
pyDir()

pyIsCallableFt <- function(x) {
    cmd <- sprintf('try:\n\tx = callable(%s)\nexcept:\n\tx=False', x)
    isTRUE(pyExecg(cmd)$x)
}

pyIsCallableFt("3 + 3")

