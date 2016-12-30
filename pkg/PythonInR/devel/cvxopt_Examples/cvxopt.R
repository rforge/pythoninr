
library(PythonInR)
library(slam)

pyImport("cvxopt")
ls()

obj <- c(-6., -4., -5.)
G <- cbind(c( 16.,  7.,  24.,  -8.,   8.,  -1.,  0.,  -1.,  0.,  0.,
               7., -5.,   1.,  -5.,   1.,  -7.,  1.,  -7., -4.),
           c(-14.,  2.,   7., -13., -18.,   3.,  0.,   0., -1.,  0.,
               3., 13.,  -6.,  13.,  12., -10., -6., -10., -28.),
           c(  5.,  0., -15.,  12.,  -6.,  17.,  0.,   0.,  0., -1.,
               9.,  6.,  -6.,   6.,  -7.,  -7., -6.,  -7., -11.))

h <- c( -3., 5., 12., -2., -14., -13., 10., 0., 0., 0.,
        68., -30., -19., -30., 99., 23., -19., 23., 10. ))
dims <- list('l'= th.int(2L), 'q'= list(th.int(4L), th.int(4L)), 's'= list(th.int(3L)))
obj <- t(t(obj))
h <- t(t(h))
sol <- cvxopt$solvers$conelp(th.cvxopt(obj), th.cvxopt(G), th.cvxopt(h), dims)
sol
G
h
dims


pySet("dims", dims)
pyExecp("type(dims)")

