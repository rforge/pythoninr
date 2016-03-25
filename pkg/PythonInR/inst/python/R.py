
"""
TODO: just import the methods needed since all is imported into the R namespace
"""

import sys
from sets import Set
PythonInR_FLAGS = {"useNumpy": True, "useSciPy": True, "usePandas": True, 
                   "useCvxOpt": True, "useNltkTree": True}
                   
try:
    if PythonInR_FLAGS['useNumpy']:
        try:
            import numpy as np
        except:
            PythonInR_FLAGS['useNumpy'] = False
    if PythonInR_FLAGS['useSciPy']:
        try:
            import scipy.sparse as sp
        except:
            PythonInR_FLAGS['useSciPy'] = False
    if PythonInR_FLAGS['usePandas']:
        try:
            import pandas as pd
        except:
            PythonInR_FLAGS['usePandas'] = False
    if PythonInR_FLAGS['useCvxOpt']:
        try:
            import cvxopt as cvxopt
        except:
            PythonInR_FLAGS['useCvxOpt'] = False
    if PythonInR_FLAGS['useNltkTree']:
        try:
            from nltk.tree import Tree as nltkTree
        except:
            PythonInR_FLAGS['useNltkTree'] = False
except:
    PythonInR_FLAGS = {"useNumpy": False, "useSciPy": False, "usePandas": False, 
                   "useCvxOpt": False, "useNltkTree": False}
    

class PythonInR_Namespace(dict):
    def __init__(self):
        from uuid import uuid1
        self.uuid1 = uuid1
    def __repr__(self):
        return( "PythonInR Namespace:  containing  %i  objects" % namespace.__len__() )
    __str__ = __repr__
    def create_uuid(self):
        return( self.uuid1().get_hex() )
    def addToNamespace(self, value):
        key = self.create_uuid()
        self.__setitem__(key, value)
        return( key )
    def removeFromNamespace(self, key):
        try:
            del self[key]
            return 0
        except:
            return -1

namespace = PythonInR_Namespace()

def addToNamespace(value):
    return namespace.addToNamespace(value)

def removeFromNamespace(key):
    try:
        del namespace.removeFromNamespace[key]
        return 0
    except:
        return -1

## ---------------------------------------------------------
##
## Data Types
##
## ---------------------------------------------------------
base_types = (bool, int, long, float, str, bytes, unicode, complex)
base_types_str = '(bool, int, long, float, str, bytes, unicode, complex)'

class tlist(list):
    """"A Typed List Class"""
    __slots__ = ['dtype']
    def __init__(self, itr, dtype):
        if (not dtype in base_types):
            raise(ValueError(" ".join("'dtype' allowed values are", base_types_str)))
        list.__init__(self, itr)
        self.dtype = dtype

class nlist(list):
    """A Named List Class"""
    __slots__ = ['names', 'dtype']
    
class vector(nlist):    
    """A Vector Class for Python"""
    def __init__(self, values, dtype, names=None):
        ## check if dtype is a basic type
        if (not dtype in base_types):
            raise(ValueError(" ".join("'dtype' allowed values are", base_types_str)))
        list.__init__(self, values)
        self.dtype = dtype
        self.names = names
        self.__class__.__name__ = "PythonInR.vector"
        
    def __repr__(self):
        s = "vector(" + str(list.__repr__(self)) + ", names: " + str(self.names)
        s += ", dtype: " + str(self.dtype.__name__) + ")"
        return s
        
    __str__ = __repr__
    
    def toR(self):
        if (self.names is None and self.dtype is None):
            return( self.toList() )
        else:
            return( self.toDict() )
            
    def toList(self):
        return list(self)
        
    def toDict(self):
        return {"values": self.toList(), "names": self.names, "dtype": self.dtype}
                        
    def toNumpy(self):
        if PythonInR_FLAGS['useNumpy']:
            return np.array(self)
        else:
            raise NameError("numpy was not found")
            
def isVector(x):
    return isinstance(x, vector)
    
def isVectorBool(x):
    if isVector(x):
        if x.dtype is bool:
            return True
    return False

def isVectorInt(x):
    if isVector(x):
        if x.dtype is int:
            return True
    return False

def isVectorLong(x):
    if isVector(x):
        if x.dtype is long:
            return True
    return False

def isVectorFloat(x):
    if isVector(x):
        if x.dtype is float:
            return True
    return False

def isVectorString(x):
    if isVector(x):
        if x.dtype is bytes:
            return True
    return False

def isUnicodeVector(x):
    if isVector(x):
        if x.dtype is unicode:
            return True
    return False

def vecBool(values, names=None):
    return( vector(values, bool, names) )
    
def vecInt(values, names=None):
    return( vector(values, int, names) )
    
def vecLong(values, names=None):
    return( vector(values, long, names) )
    
def vecFloat(values, names=None):
    return( vector(values, float, names) )
    
def vecString(values, names=None):
    return( vector(values, bytes, names) )

def vecUnicode(values, names=None):
    return( vector(values, unicode, names) )

class matrix(list): 
    """A Matrix Class for Python"""
    __slots__ = ['names', 'dtype']
    def __init__(self, matrix, rownames=None, colnames=None, dim=None, dtype=None):
        list.__init__(self, matrix)
        self.rownames = rownames 
        self.colnames = colnames 
        self.dim = (0,0) if (dim is None) else tuple(dim)
        self.dtype = dtype
        self.__class__.__name__ = "PythonInR.matrix"
    
    def __repr__(self):
         s = "matrix(["
         offset = len(s)
         for i, row in enumerate(self):
             if (i > 0):
                 s += " " * offset     
             s += str(row) 
             if ((i+1) < len(self)):
                 s += ",\n"
         s += "])"
         return s
         
    __str__ = __repr__
    
    def toR(self):
        return( self.toDict() )

    def flatten(self):
        return( [rec for row in self for rec in row] )
    
    def toList(self):
        return(list(self))
    
    def toDict(self):
        return( {"values": self.toList(), "rownames": self.rownames, 
                "colnames": self.colnames, "dim": self.dim, "dtype": self.dtype} )
                
    def toNumpy(self):
        if PythonInR_FLAGS['useNumpy']:
            return np.array(self)
        else:
            raise NameError("numpy was not found")

    def toSciPySparseMatrix(self):
        """Sparse matrix in COOrdinate format"""
        if PythonInR_FLAGS['useSciPy']:
            return sp.coo_matrix(self.toNumpyArray())
        else:
            raise NameError("scipy.sparse was not found")

    def toBsr(self):
        """Block Sparse Row matrix"""
        return self.toSciPySparseMatrix().tobsr()

    def toCoo(self):
        """Sparse matrix in COOrdinate format"""
        return self.toSciPySparseMatrix() ## debu

    def toCsc(self):
        """Compressed Sparse Column matrix"""
        return self.toSciPySparseMatrix().tocsc()

    def toCsr(self):
        """Compressed Sparse Row matrix"""
        return self.toSciPySparseMatrix().tocsr()

    def toDense(self):
        """Dense Matrix"""
        return self.toSciPySparseMatrix().todense()

    def toDia(self):
        """Sparse matrix with DIAgonal storage"""
        return self.toSciPySparseMatrix().todia()

    def toDok(self):
        """Dictionary Of Keys based sparse matrix"""
        return self.toSciPySparseMatrix().todok()

    def toLil(self):
        """Row-based linked list sparse matrix"""
        return self.toSciPySparseMatrix().tolil()

    def toCvxOptBaseMatrix(self):
        """CVXOPT Base Matrix """
        if PythonInR_FLAGS['useCvxOpt']:
            return cvxopt.matrix(self.toNumpyArray())
        else:
            raise NameError("CVXOPT was not found")

    def toCvxOptSparseMatrix(self):
        """CVXOPT Sparse Matrix """
        if PythonInR_FLAGS['useCvxOpt']:
            return cvxopt.sparse(self.toCvxOptBaseMatrix())
        else:
            raise NameError("CVXOPT was not found")


class array(object): 
    """A array class"""
    def __init__(self, array, dimnames=None, dim=None, dtype=None):
        self.values = array 
        self.dimnames = dimnames 
        self.dim = dim
        self.dtype = dtype
        self.__class__.__name__ = "PythonInR.array"
    
    def __repr__(self):
        s = "array(" + str(self.values) + ", 'dimnames': " + str(self.dimnames)
        s += ", 'dtype': '" + str(self.dtype) + "')"
        return s
    
    __str__ = __repr__

    def toR(self):
        return( self.toDict() )

    def toDict(self):
        d = dict()
        d['values'] = self.values
        d['dimnames'] = self.dimnames
        d['dim'] = self.dim
        d['dtype'] = self.dtype
        return(d)
    
    def toList(self):
        return(self.values)
    
    def toNumpyArray(self):
        if PythonInR_FLAGS['useNumpy']:
            return np.array(self.values).reshape(self.dim)
        else:
            raise NameError("numpy was not found")


class simple_triplet_matrix(object):
    def __init__(self, i, j, v, nrow=None, ncol=None, dimnames=None, dtype=None): 
        self.i = i
        self.j = j
        self.v = v
        self.nrow = max(self.i) if (nrow is None and len(self.i)) else nrow
        self.ncol = max(self.j) if (ncol is None and len(self.j)) else ncol
        self.dimnames = dimnames
        self.dtype = dtype
        self.__class__.__name__ = "PythonInR.simple_triplet_matrix"
        
    def __repr__(self):
         s = "A %ix%i simple triplet matrix." % (self.nrow, self.ncol)
         return s
         
    __str__ = __repr__

    def __cleanup__(self):
        self.i = None
        self.j = None
        self.v = None
        self.nrow = None
        self.ncol = None
        self.dimnames = None
        self.dtype = None

    def fromDict(self, x):
        self.i = x['i']
        self.j = x['j']
        self.v = x['v']
        self.nrow = x['nrow']
        self.ncol = x['ncol']
        self.dimnames = x['dimnames']
        return self

    def toR(self):
        return( self.toDict() )
       
    def toDict(self):
        d = dict()
        d['i'] = self.i
        d['j'] = self.j
        d['v'] = self.v
        d['nrow'] = self.nrow
        d['ncol'] = self.ncol
        d['dimnames'] = self.dimnames
        d['dtype'] = self.dtype
        return( d )
    
    def toNumpyMatrix(self):
        """Numpy Matrix"""
        return np.matrix(self.toNumpyArray())
    
    def toNumpyArray(self):
        return self.toSciPySparseMatrix().toarray()
    
    def toSciPySparseMatrix(self):
        """Sparse matrix in COOrdinate format"""
        if PythonInR_FLAGS['useSciPy']:
            return sp.coo_matrix((np.array(self.v), (np.array(self.i), np.array(self.j))),
                                 shape=(self.nrow, self.ncol))
        else:
            raise NameError("scipy.sparse was not found")

    def toBsr(self):
        """Block Sparse Row matrix"""
        return self.toSciPySparseMatrix().tobsr()

    def toCoo(self):
        """Sparse matrix in COOrdinate format"""
        return self.toSciPySparseMatrix()
                                 
    def toCsc(self):
        """Compressed Sparse Column matrix"""
        return self.toSciPySparseMatrix().tocsc()

    def toCsr(self):
        """Compressed Sparse Row matrix"""
        return self.toSciPySparseMatrix().tocsr()

    def toDense(self):
        """Dense Matrix"""
        return self.toSciPySparseMatrix().todense()

    def toDia(self):
        """Sparse matrix with DIAgonal storage"""
        return self.toSciPySparseMatrix().todia()

    def toDok(self):
        """Dictionary Of Keys based sparse matrix"""
        return self.toSciPySparseMatrix().todok()

    def toLil(self):
        """Row-based linked list sparse matrix"""
        return self.toSciPySparseMatrix().tolil()

    def toCvxOptBaseMatrix(self):
        """CVXOPT Base Matrix """
        if PythonInR_FLAGS['useCvxOpt']:
            return cvxopt.matrix(self.toNumpyArray())
        else:
            raise NameError("CVXOPT was not found")

    def toCvxOptSparseMatrix(self):
        """CVXOPT Sparse Matrix """
        if PythonInR_FLAGS['useCvxOpt']:
            return cvxopt.spmatrix(sef.v, sef.i, sef.j, size=(self.nrow, self.ncol))
        else:
            raise NameError("CVXOPT was not found")


##class simple_sparse_array(sparse):


class dataFrame(object): 
    """A data.frame class"""
    def __init__(self, dataFrame, rownames, colnames, dim, dtype): 
        self.values = dataFrame
        self.rownames = rownames
        self.colnames = colnames 
        self.dim = tuple(dim) if (len(dim) == 2) else (-1, -1)
        self.dtype = dtype
        self.__class__.__name__ = "PythonInR.dataFrame"

    def __repr__(self):
        try:
            s = "'dataFrame':    %i obs. of  %i variables:\n" % tuple(self.dim)
        except:
            s = "'dataFrame':"
        try:
            offset = max([len(k) for k in self.values.keys()])
            seq = range(0, (min(self.dim[0], 5)))
            for key in self.values.keys():
                s += "  " + str(key) + (offset - len(str(key))) * " " + ":"
                for i in seq:
                    s += " " + str(self.values[key][i])
                s += "\n"
        except:
            pass
        return( s )
    
    __str__ = __repr__

    def toR(self):
        return( self.toDict() )

    def toDict(self):
        return( {"data.frame": self.values, "rownames": self.rownames, 
                 "colnames": self.colnames, "dim": self.dim} )

    def toPandas(self):
        return( pd.DataFrame(self.values) )

def is_nlp_tree(x):
    if isinstance(x, dict):
        if (len( Set(x.keys()).difference(['children', 'value']) ) == 0):
            return(True)
    return(False)

def nlp_tree_to_nltk_tree(x):
    tree = nltkTree(x['value'], [])
    for child in x['children']:
        if is_nlp_tree(child):
            tree.append(dict_to_tree(child))
        else:
            tree.append(child)
    return(tree)

def nltk_tree_to_dict(tree):
    tdict = {'value': tree._label, 'children': []}
    for child in tree:
        if isinstance(child, nltkTree):
            tdict['children'].append(nltk_tree_to_dict(child))
        else:
            tdict['children'].append(child)
    return(tdict)

class PythonInR_Error(object):
    """An Error Object which allows to do all the cleanup and other things and give the message to R."""
    def __init__(self, message=None, domain=None, error_type=None):
        self.message = message
        self.domain = domain
        self.error_type = error_type
        self.__class__.__name__ = "PythonInR.error"

    def toR(self):
        return( {'message': self.message, 'domain': self.domain, 'error_type': self.error_type} )


class tree(object):
    """A tree class"""
    def __init__(self, tree):
        self.tree = tree
        self.dtype = "PythonInR.Tree"

    def __repr__(self):
        return str(self.tree)

    __str__ = __repr__

    def toDict(self):
        return(self.tree)

    def toNltkTree(self):
        if PythonInR_FLAGS['useNltkTree']:
            return( nlp_tree_to_nltk_tree(self.tree) )
        else:
            raise NameError("nltk was not found")

def new_python_object(x, type):
    if ( type == 1 ):
        if PythonInR_FLAGS['useNltkTree']:
            return tree(x).toNltkTree()
        else:
            return tree(x)

def toR(x, autotype):
    print("toR")
    if (not autotype):
        rval = dict()
        rval['id'] = "__R__.namespace['%s']" % namespace.addToNamespace(x)
        try:
            rval['isCallable'] = callable(x)
        except:
            rval['isCallable'] = False
        try:
            rval['type'] = type(x).__name__
        except:
            rval['type'] = None
        return(rval)
    if PythonInR_FLAGS['useNumpy']:
        if isinstance(x, np.ndarray):
            if len(x.shape) == 1:
                return( vector(x.tolist(), None) )
            if len(x.shape) == 2:
                return( matrix(x.tolist()) )
            if len(x.shape) > 2:
                return( array(x.flatten().tolist()) )
    if PythonInR_FLAGS['useSciPy']:
        if ( sp.isspmatrix(x) ):
            return( scipy_sparse_to_slam(x) )
    if PythonInR_FLAGS['usePandas']:
        if isinstance(x, pd.DataFrame):
            return( dataFrame(x.to_dict(), list(x.index), list(x.keys()), df.shape, None) )
    if PythonInR_FLAGS['useCvxOpt']:
        if isinstance(x, cvxopt.spmatrix):
            return( scipy_sparse_to_slam(cvxopt_csc_matrix_to_scipy_csc_matrix(x)) )
        if isinstance(x, cvxopt.matrix):
            if PythonInR_FLAGS['useNumpy']:
                return( matrix(np.array(A).tolist()) )
    if PythonInR_FLAGS['useNltkTree']:
        if isinstance(x, nltkTree):
            return( nltk_tree_to_dict(x) )
    rval = dict()
    rval['id'] = "__R__.namespace['%s']" % namespace.addToNamespace(x)
    try:
        rval['isCallable'] = callable(x)
    except:
        rval['isCallable'] = False
    try:
        rval['type'] = type(x).__name__
    except:
        rval['type'] = None
    return(rval)

def cvxopt_csc_matrix_to_scipy_csc_matrix(x):
    indptr = array(x.CCS[0]).reshape(len(x.CCS[0]),)
    indices = array(x.CCS[1]).reshape(len(x.CCS[1]),)
    data = array(x.CCS[2]).reshape(len(x.CCS[2]),)
    return sp.csc_matrix((data, indices, indptr), shape=x.size).toarray()

def scipy_sparse_to_slam(x):
    if ( sp.isspmatrix_coo(x) ):
        return( simple_triplet_matrix(list(x.row), list(x.col), list(x.data), 
            x.shape[0], x.shape[1], None,  x.data.dtype) )
    if ( sp.isspmatrix_bsr(x) ):
        return ( scipy_sparse_to_slam( x.tocoo() ) )
    if ( sp.isspmatrix_csc(x) ):
        return ( scipy_sparse_to_slam( x.tocoo() ) )
    if ( sp.isspmatrix_csr(x) ):
        return ( scipy_sparse_to_slam( x.tocoo() ) )
    if ( sp.isspmatrix_dia(x) ):
        return ( scipy_sparse_to_slam( x.tocoo() ) )
    if ( sp.isspmatrix_dok(x) ):
        return ( scipy_sparse_to_slam( x.tocoo() ) )
    if ( sp.isspmatrix_lil(x) ):
        return ( scipy_sparse_to_slam( x.tocoo() ) )
    return(x)

