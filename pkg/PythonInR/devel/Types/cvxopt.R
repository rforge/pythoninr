
library("PythonInR")

BEGIN.Python()

import cvxopt
from cvxopt import matrix
from numpy import array
import numpy as np
import scipy.sparse as sp

A = matrix([[1,2,3],[4,5,6]])
print(A)
type(A)

np.array(A).tolist()
B
type(matrix(B))

C = array(A)
type(C)
dir(C)
B
np.matrix(B)
np.matrix(D)
C.tomatrix()

B = array(A)
B.shape
sp.csc_matrix(B)
type(B)
Z = __R__.sp.csc_matrix(B)
dir(Z)
print(sparse(matrix(B)))

from cvxopt import spmatrix
D = spmatrix([1., 2.], [0, 1], [0, 1], (4,2))
print(D)
D.size
type(D)
dir(D)
dir(D.CCS)
type(D.CCS[1])
print(D.CCS[0])
print(D.CCS[1])
print(D.CCS[2])
array(D.CCS[2]).reshape(2,)
array([1, 2, 3, 4, 5, 6])

indptr = array(D.CCS[0]).reshape(3,)
indices = array(D.CCS[1]).reshape(2,)
data = array(D.CCS[2]).reshape(2,)
sp.csc_matrix((data, indices, indptr), shape=D.size).toarray()

x = D

def cvxopt_csc_matrix_to_scipy_csc_matrix(x):
	indptr = array(x.CCS[0]).reshape(len(x.CCS[0]),)
	indices = array(x.CCS[1]).reshape(len(x.CCS[1]),)
	data = array(x.CCS[2]).reshape(len(x.CCS[2]),)
	return sp.csc_matrix((data, indices, indptr), shape=x.size).toarray()




from cvxopt import sparse
B = matrix([ [1.0, 2.0], [3.0, 4.0] ])
E = sparse([ [B, B], [D] ])
type(E)
print(E)
dir(E)
type(E)
E.CCS

from cvxopt import spdiag
print(spdiag([B, -B, 1, 2]))

##          V             I       J
print(spmatrix([8, 9], [0, 1], [1, 0], size=(2,2)))

END.Python
