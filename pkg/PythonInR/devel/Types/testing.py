# -*- coding: utf-8 -*-
"""
Created on Sun Feb  7 11:22:13 2016

@author: florian
"""

import cvxopt
import numpy as np

import sys
import R as r

dir(r)

"""
   Vector
"""

y = np.int_([1,2,4])
y
x = r.vector([1, 2, 3], None, "numeric")
x
type(x).__name__


"""
   Matrix
"""
mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
M = r.matrix(mat, None, None, (3,3), "numeric")
type(M)
M

## flatten
M.flatten()
## to numpy
M.toNdArray()
## to cvxopt matrix
M.toCvxOptMatrix()


"""
   Simple Triplet Matrix
"""
SM = r.simple_triplet_matrix([0,1,2], [0,1,2], [1,2,3], 3, 3)
SM
SM.i
SM.nrow
SM.ncol
x = SM.toSciPySparseMatrix()
dir(x)
type(x.toarray())

x.toarray().tolist()

x.toarray()



from scipy.sparse import coo_matrix
coo_matrix((np.array(SM.v), (np.array(SM.i), np.array(SM.j))), 
                              shape=(SM.nrow, SM.ncol))


dir(sys)
z
sys.__package__

np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

d = {"x": [1,2,3], "names": ["a", "b", "c"], "type": "integer"}
d

dir(r)

R = R.PythonInR()
dir(R)

x = np.matrix('1 2; 3 4')
type(x).__name__

cvxopt

y
np.array([1, 2, 3], dtype='f')
type(y).__name__

"""
cvxopt matrix
"""
from cvxopt import matrix


"""
scipy sparse matrix
"""
import scipy.sparse

sp = scipy.sparse.csc_matrix((5, 10))
sp[0, 0] = 10
sp[2, 3] = 30
sp
dir(sp)
sp.shape
sp.data
sp.indices
sp.indptr

class PythonInR(object):
    def __init__(self):
        self.namespace = dict()

    def addToNamespace(self, key, value):
        self.namespace[key] = value

    def removeFromNamespace(self, key):
        try:
            del self.namespace[key]
            return 0
        except:
            return -1
            
    class vector(object):
        pass
        
    class matrix(object):
        pass
    
    class virtualMatrix(object):
        pass        
    
    class dgeMatrix(virtualMatrix):
        pass
    
    class dgcMatrix(virtualMatrix):
        pass
    
    class array(object):
        pass
    
    class dataFrame(object):
        pass
    
    


    class PrVector(object): 
        """A pretty rudimentary Vector class!"""
        def __init__(self, vector, names, rClass): 
            if (not (rClass in ("logical", "integer", "numeric", "character"))):
                raise ValueError("rclass is no valid class name in R")
            self.x = vector
            self.names = names
            self.rClass = rClass

        def __repr__(self):
            s = "prVector"
            s += "\\nnames:  " + str(self.names)
            s += "\\nvalues: " + str(self.x)
            return s

        __str__ = __repr__

        def toDict(self):
            return {"vector": self.x, "names": self.names, "rClass": self.rClass}

class matrix(object): 
    """A pretty rudimentary Matrix class!"""
    def __init__(self, matrix, rownames, colnames, dim): 
        self.x = matrix 
        self.rownames = rownames 
        self.colnames = colnames 
        self.dim = (0,0) if (dim is None) else tuple(dim)
    
    def __repr__(self):
         s = "prMatrix:" + "\\n\\t%i columns\\n\\t%i rows\\n" % self.dim
         return s + str(self.x)
    
    def toDict(self):
        return {"matrix": self.x, "rownames": self.rownames, "colnames": self.colnames, "dim": self.dim}



class slam(object):
    def __init__(self):
        pass
    
    class matrix(object):
        def __init__(self, i, j, v, nrow, ncol, dimnames):    
            self.i = i
            self.j = j
            self.v = v
            self.nrow = nrow
            self.ncol = ncol
            self.dimnames = dimnames
        
        def __repr__(self):

        def toList(self):
            pass
            
        def toDict(self):
            pass
        
        def toArray(self):
            pass            
        
    class array(object):
    
