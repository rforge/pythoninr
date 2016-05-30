
"""
TODO: just import the methods needed since all is imported into the R namespace
"""

import sys
from collections import OrderedDict
from sets import Set
from warnings import warn
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

class ttuple(tuple):
    """A Typed tuple Class"""
    def __new__(self, tup, dtype):
        if (not dtype in base_types):
            raise(ValueError(" ".join("'dtype' allowed values are", base_types_str)))
        self.dtype = dtype
        return tuple.__new__(self, tup)

    def _r_type(self):
        return _get_r_type(self.dtype)
        
def ttuple_bool(values):
    return( ttuple(values, bool) )

def ttuple_int(values):
    return( ttuple(values, int) )
    
def ttuple_long(values):
    return( ttuple(values, long) )
    
def ttuple_float(values):
    return( ttuple(values, float) )

def ttuple_string(values):
    return( ttuple(values, bytes) )

def ttuple_unicode(values):
    return( ttuple(values, unicode) )

def is_ttuple(x):
    return isinstance(x, ttuple)

class tlist(list):
    """A Typed List Class"""
    __slots__ = ['dtype']
    def __init__(self, itr, dtype):
        if (not dtype in base_types):
            raise(ValueError(" ".join("'dtype' allowed values are", base_types_str)))
        list.__init__(self, itr)
        self.dtype = dtype

    def _r_type(self):
        return _get_r_type(self.dtype)
        
def tlist_bool(values):
    return( tlist(values, bool) )

def tlist_int(values):
    return( tlist(values, int) )
    
def tlist_long(values):
    return( tlist(values, long) )
    
def tlist_float(values):
    return( tlist(values, float) )

def tlist_string(values):
    return( tlist(values, bytes) )

def tlist_unicode(values):
    return( tlist(values, unicode) )

def is_tlist(x):
    return isinstance(x, tlist)

def _get_r_type(o):
    if (o is None):
        return 0
    if (o is bool):
        return 10
    if ((o is int) or (o is long)):
        return 13
    if (o is float):
        return 14
    if ((o is bytes) or (o is unicode)):
        return 16
    if (o is list):
        return 2 ## since matrices can also be of type "list"
    return -1

def _get_py_type_numpy(o):
    o = o.dtype.kind
    if (o is 'b'):
        return bool
    if (o in ('i', 'u')):
        return int
    if (o is 'f'):
        return float
    if (o in ('S', 'a', 'U')):
        return unicode
    return -1
    
def _get_py_type_cvxopt(o):
    if (o is 'i'):
        return int
    if (o is 'd'):
        return float
    return -1

def _get_r_type_numpy(o):
    o = o.dtype.kind
    if (o is 'b'):
        return 10
    if (o in ('i', 'u')):
        return 13
    if (o is 'f'):
        return 14
    if (o in ('S', 'a', 'U')):
        return 16
    return -1

def _int_to_dtype(i):
    if (i == 10):
        return bool
    if (i == 12):
        return int
    if (i == 13):
        return long
    if (i == 14):
        return float
    if (i == 16):
        return bytes
    if (i == 17):
        return unicode
    return None


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

    def _r_type(self):
        return _get_r_type(self.dtype)

    def _has_names(self):
        return not self.names is None
    
    def to_r(self):
        if (self.names is None and self.dtype is None):
            return( self.to_list() )
        else:
            return( self.to_dict() )
            
    def to_list(self):
        return list(self)
        
    def to_dict(self):
        return {"values": self.to_list(), "names": self.names, "dtype": self.dtype}
                        
    def to_numpy(self):
        if PythonInR_FLAGS['useNumpy']:
            return np.array(self)
        else:
            raise NameError("numpy was not found")
            
def is_vector(x):
    return isinstance(x, vector)
    
def is_vector_bool(x):
    if is_vector(x):
        if x.dtype is bool:
            return True
    return False

def is_vector_int(x):
    if is_vector(x):
        if x.dtype is int:
            return True
    return False

def is_vector_long(x):
    if is_vector(x):
        if x.dtype is long:
            return True
    return False

def is_vector_float(x):
    if is_vector(x):
        if x.dtype is float:
            return True
    return False

def is_vector_string(x):
    if is_vector(x):
        if x.dtype is bytes:
            return True
    return False

def is_unicode_vector(x):
    if is_vector(x):
        if x.dtype is unicode:
            return True
    return False

def is_numpy_array(x):
    try:
        return isinstance(x, (np.ndarray, np.generic))
    except:
        return False

def is_numpy_vector(x):
    if is_numpy_array(x):
        return ( len(x.shape) == 1 )
    return False

def vec_bool(values, names=None):
    return( vector(values, bool, names) )
    
def vec_int(values, names=None):
    return( vector(values, int, names) )
    
def vec_long(values, names=None):
    return( vector(values, long, names) )
    
def vec_float(values, names=None):
    return( vector(values, float, names) )
    
def vec_string(values, names=None):
    return( vector(values, bytes, names) )

def vec_unicode(values, names=None):
    return( vector(values, unicode, names) )

def numpy_array(values):
    if ( PythonInR_FLAGS['useNumpy'] ):
        return np.array(values)
    return values
    

def numpy_vector_to_tlist(values):
    return tlist(values, _get_py_type_numpy(values))


class matrix(list): 
    """A Matrix Class for Python"""
    __slots__ = ['dim', 'dimnames', 'dtype']
    def __init__(self, matrix, dim, dimnames, dtype=None):
        list.__init__(self, matrix)
        self.dimnames = dimnames
        self.dim = (0,0) if (dim is None) else tuple(dim)
        self.dtype = dtype
        self.__class__.__name__ = "PythonInR.matrix"
    
    def __repr__(self):
         s = "matrix(" + str(list(self)) + ")"
         return s
         
    __str__ = __repr__

    def _r_type(self):
        return _get_r_type(self.dtype)

    def nrow(self):
        return self.dim[0]

    def ncol(self):
        return self.dim[1]

    def rownames(self):
        return self.dimnames[0] if (len(self.dimnames) > 0) else None

    def colnames(self):
        return self.dimnames[1] if (len(self.dimnames) > 1) else None
    
    def to_r(self):
        return( {"data": tlist(self, self.dtype), "dimnames": self.dimnames, 
                 "nrow": self.nrow(), "ncol": self.ncol()} )

    def to_list_of_list(self):
        lol = list()
        for m in xrange(self.nrow()):
            col = list()
            for n in xrange(self.ncol()):
                col.append(self[(n * self.nrow()) + m])
            lol.append(col)
        return( lol )
    
    def to_list(self):
        return(list(self))
    
    def to_dict(self):
        return( {"values": self, "dimnames": self.dimnames, 
                 "dim": self.dim, "dtype": _get_r_type(self.dtype)} )
                
    def to_numpy(self):
        if PythonInR_FLAGS['useNumpy']:
            return (np.array(self).reshape(tuple(reversed(self.dim))).transpose())
        else:
            raise NameError("numpy was not found")

    def to_scipy_sparse_matrix(self):
        """Sparse matrix in COOrdinate format"""
        if PythonInR_FLAGS['useSciPy']:
            return sp.coo_matrix(self.to_numpy())
        else:
            raise NameError("scipy.sparse was not found")

    def to_bsr(self):
        """Block Sparse Row matrix"""
        return self.to_scipy_sparse_matrix().tobsr()

    def to_coo(self):
        """Sparse matrix in COOrdinate format"""
        return self.to_scipy_sparse_matrix() ## debu

    def to_csc(self):
        """Compressed Sparse Column matrix"""
        return self.to_scipy_sparse_matrix().tocsc()

    def to_csr(self):
        """Compressed Sparse Row matrix"""
        return self.to_scipy_sparse_matrix().tocsr()

    def to_dia(self):
        """Sparse matrix with DIAgonal storage"""
        return self.to_scipy_sparse_matrix().todia()

    def to_dok(self):
        """Dictionary Of Keys based sparse matrix"""
        return self.to_scipy_sparse_matrix().todok()

    def to_lil(self):
        """Row-based linked list sparse matrix"""
        return self.to_scipy_sparse_matrix().tolil()

    def to_cvxopt_matrix(self):
        """CVXOPT Base Matrix """
        if PythonInR_FLAGS['useCvxOpt']:
            return cvxopt.matrix(self, self.dim)
        else:
            raise NameError("CVXOPT was not found")

    def to_cvxopt_sparse_matrix(self):
        """CVXOPT Sparse Matrix """ ##  TODO: this conversion can be done more efficent!
        if PythonInR_FLAGS['useCvxOpt']:
            return cvxopt.sparse(self.to_cvxopt_matrix())
        else:
            raise NameError("CVXOPT was not found")


def matrix_bool(values, dim, dimnames=None):
    return( matrix(values, dim, dimnames, dtype=bool) )
    
def matrix_int(values, dim, dimnames=None):
    return( matrix(values, dim, dimnames, int) )
    
def matrix_long(values, dim, dimnames=None):
    return( matrix(values, dim, dimnames, long) )
    
def matrix_float(values, dim, dimnames=None):
    return( matrix(values, dim, dimnames, float) )
    
def matrix_string(values, dim, dimnames=None):
    return( matrix(values, dim, dimnames, bytes) )

def matrix_unicode(values, dim, dimnames=None):
    return( matrix(values, dim, dimnames, unicode) )

def matrix_matrix(values, dim, dimnames=None):
    return( matrix(values, dim, dimnames, unicode) )

def matrix_to_numpy(values):
    if ( PythonInR_FLAGS['useNumpy'] ):
        return values.to_numpy()
    return values

def matrix_to_cvxopt(values):
    if ( PythonInR_FLAGS['useCvxOpt'] ):
        return values.to_cvxopt_matrix()
    return values

## is_matrix(matrix([1, 2], (2, 2), None))
def is_matrix(x):
    return isinstance(x, matrix)
        
def is_numpy_matrix(x):
    if is_numpy_array(x):
        return ( len(x.shape) == 2 )
    return False

def is_bsr_matrix(x):
    try:
        return sp.isspmatrix_bsr(x)
    except:
        return False

def is_coo_matrix(x):
    try:
        return sp.isspmatrix_coo(x)
    except:
        return False
        
def is_csc_matrix(x):
    try:
        return sp.isspmatrix_csc(x)
    except:
        return False

def is_csr_matrix(x):
    try:
        return sp.isspmatrix_csr(x)
    except:
        return False
        
def is_dia_matrix(x):
    try:
        return sp.isspmatrix_dia(x)
    except:
        return False

def is_dok_matrix(x):
    try:
        return sp.isspmatrix_dok(x)
    except:
        return False

def is_lil_matrix(x):
    try:
        return sp.isspmatrix_lil(x)
    except:
        return False

def is_cvxopt_matrix(x):
    try:
        return isinstance(x, cvxopt.matrix)
    except:
        return False

def is_cvxopt_sparse_matrix(x):
    try:
        return isinstance(x, cvxopt.spmatrix)
    except:
        return False

def numpy_matrix_to_dict(x):
    dim = x.shape
    return {'data': tlist(x.flatten(), _get_py_type_numpy(x)), 'nrow': dim[0], 
            'ncol': dim[1], 'dimnames': None}

def cvxopt_matrix_to_dict(x):
    dim = x.size
    return {'data': tlist(list(x), _get_py_type_cvxopt(x.typecode)), 
            'nrow': dim[0], 'ncol': dim[1], 'dimnames': None}

class array(list): 
    """A array class"""
    __slots__ = ['dim', 'dimnames', 'dtype']
    def __init__(self, array, dim, dimnames=None, dtype=None):
        list.__init__(self, array)
        self.dimnames = dimnames
        self.dim = (0,0) if (dim is None) else tuple(dim)
        self.dtype = dtype
        self.__class__.__name__ = "PythonInR.array"
    
    def __repr__(self):
        s = "array(" + str(list(self)) + ", 'dimnames': " + str(self.dimnames)
        s += ", 'dtype': '" + str(self.dtype) + "')"
        return s
    
    __str__ = __repr__

    def to_r(self):
        d = dict()
        d['data'] = tlist(self, self.dtype)
        d['dimnames'] = self.dimnames
        d['dim'] = self.dim
        return( d )

    def to_dict(self):
        d = dict()
        d['data'] = list(self)
        d['dimnames'] = self.dimnames
        d['dim'] = self.dim
        d['dtype'] = _get_r_type(self.dtype)
        return(d)
    
    def to_list(self):
        return(self)
    
    def to_numpy(self):
        if PythonInR_FLAGS['useNumpy']:
            ## return (np.array(self).reshape(tuple(reversed(self.dim))).transpose())
            return np.array(self).reshape(self.dim)
        else:
            raise NameError("numpy was not found")

def new_array(data, dim, dimnames, dtype):
    return array(data, dim, dimnames, _int_to_dtype(dtype))

def is_array(x):
    return isinstance(x, array)

def numpy_array_to_tlist(x):
    d = dict()
    d['data'] = numpy_vector_to_tlist(x.flatten())
    d['dim'] = x.shape
    return(d)


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

    def from_dict(self, x):
        self.i = x['i']
        self.j = x['j']
        self.v = x['v']
        self.nrow = x['nrow']
        self.ncol = x['ncol']
        self.dimnames = x['dimnames']
        return self

    def to_r(self):
        d = dict()
        d['i'] = tlist([(i+1) for i in self.i], int)
        d['j'] = tlist([(j+1) for j in self.j], int)
        d['v'] = tlist(self.v, self.dtype)
        d['nrow'] = self.nrow
        d['ncol'] = self.ncol
        d['dimnames'] = self.dimnames
        return( d )
       
    def to_dict(self):
        d = dict()
        d['i'] = self.i
        d['j'] = self.j
        d['v'] = self.v
        d['nrow'] = self.nrow
        d['ncol'] = self.ncol
        d['dimnames'] = self.dimnames
        d['dtype'] = self.dtype
        return( d )
    
    def to_numpy_matrix(self):
        """Numpy Matrix"""
        return np.matrix(self.to_numpy())
    
    def to_numpy(self):
        return self.to_scipy_sparse_matrix().toarray()
    
    def to_scipy_sparse_matrix(self):
        """Sparse matrix in COOrdinate format"""
        if PythonInR_FLAGS['useSciPy']:
            return sp.coo_matrix((np.array(self.v), (np.array(self.i), np.array(self.j))),
                                 shape=(self.nrow, self.ncol))
        else:
            raise NameError("scipy.sparse was not found")

    def to_bsr(self):
        """Block Sparse Row matrix"""
        return self.to_scipy_sparse_matrix().tobsr()

    def to_coo(self):
        """Sparse matrix in COOrdinate format"""
        return self.to_scipy_sparse_matrix()
                                 
    def to_csc(self):
        """Compressed Sparse Column matrix"""
        return self.to_scipy_sparse_matrix().tocsc()

    def to_csr(self):
        """Compressed Sparse Row matrix"""
        return self.to_scipy_sparse_matrix().tocsr()

    def to_dense(self):
        """Dense Matrix"""
        return self.to_scipy_sparse_matrix().todense()

    def to_dia(self):
        """Sparse matrix with DIAgonal storage"""
        return self.to_scipy_sparse_matrix().todia()

    def to_dok(self):
        """Dictionary Of Keys based sparse matrix"""
        return self.to_scipy_sparse_matrix().todok()

    def to_lil(self):
        """Row-based linked list sparse matrix"""
        return self.to_scipy_sparse_matrix().tolil()

    def to_cvxopt_matrix(self):
        """CVXOPT Base Matrix """
        if PythonInR_FLAGS['useCvxOpt']:
            return cvxopt.matrix(self.to_numpy())
        else:
            raise NameError("CVXOPT was not found")

    def to_cvxopt_sparse_matrix(self):
        """CVXOPT Sparse Matrix """
        if PythonInR_FLAGS['useCvxOpt']:
            return cvxopt.spmatrix(self.v, self.i, self.j, size=(self.nrow, self.ncol))
        else:
            raise NameError("CVXOPT was not found")


def simple_triplet_matrix_from_dict(d):
    i = [(i-1) for i in d['i']]
    j = [(j-1) for j in d['j']]
    return simple_triplet_matrix(i, j, d['v'], d['nrow'], d['ncol'], d['dimnames'], d['v'].dtype)

def is_simple_triplet_matrix(x):
    return isinstance(x, simple_triplet_matrix)

##class simple_sparse_array(sparse):

class data_frame(dict):
    """A data.frame class"""
    __slots__ = ['dim', 'rownames', 'colnames']
    def __init__(self, df, rownames=None, colnames=None, dim=None):
        dict.__init__(self, df)
        if (dim is None):
            ncol = len(self)
            row_lens = set([len(col) for col in self.values()])
            if (len(row_lens) != 1):
                raise IndexError("All columns need to have the same number of rows!")
            nrow = list(row_lens)[0]
            self.dim = (nrow, ncol)
        else:
            self.dim = tuple(dim)
        if (rownames is None):
            self.rownames = [str(i+1) for i in range(self.dim[0])]
        else:
            self.rownames = rownames
        if (colnames is None):
            self.colnames = self.keys()
        else:
            self.colnames = colnames

        self.__class__.__name__ = "PythonInR.data_frame"

    def __repr__(self):
        try:
            s = "'data_frame': %i rows %i columns\n" % tuple(self.dim)
        except:
            pass
        return( s )
    
    __str__ = __repr__

    def to_r(self):
        """
        try:
            data = [self[k] for k in self.colnames]
            return( {'data': data, 'rownames': self.rownames, 'colnames': self.colnames} )
        except:
        """
        data = dict(self)
        return( {'data': data, 'rownames': self.rownames, 'colnames': self.keys} )

    def to_dict(self):
        return( dict(self) )

    def to_pandas(self):
        if PythonInR_FLAGS['usePandas']:
            x = self.copy()
            for k in x.keys():
                x[k] = list(x[k])
            if ( len(self.rownames) == self.dim[0] ):
                return( pd.DataFrame(data=x, index=list(self.rownames)) )
            else:
                return( pd.DataFrame(data=x) )
        else:
            raise NameError("PANDAS was not found")


def new_data_frame(df, rownames, colnames, dim):
    return data_frame(df, rownames, colnames, dim)

def is_data_frame(x):
    return isinstance(x, data_frame)

def pandas_data_frame_to_dict(x):
    try:
        data = x.to_dict()
        for k in data.keys():
            if isinstance(data[k], dict):
                data[k] = data[k].values()
        return {'data': data, 'rownames': list(x.index), 'colnames': data.keys()}
    except:
        return x.to_dict()

def is_nlp_tree(x):
    if isinstance(x, dict):
        if (len( Set(x.keys()).difference(['children', 'value']) ) == 0):
            return(True)
    return(False)

def nlp_tree_to_nltk_tree(x):
    xtree = nltkTree(x['value'], [])
    for child in x['children']:
        if is_nlp_tree(child):
            xtree.append(nlp_tree_to_nltk_tree(child))
        else:
            xtree.append(child)
    return(xtree)

def nltk_tree_to_dict(xtree):
    tdict = {'value': xtree._label, 'children': []}
    for child in xtree:
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

    def to_r(self):
        return( {'message': self.message, 'domain': self.domain, 'error_type': self.error_type} )




class tree(dict):
    """A tree class"""
    def __init__(self, tree):
        dict.__init__(self, tree)
        self.__class__.__name__ = "PythonInR.Tree"

    def __repr__(self):
        return str(dict(self))

    __str__ = __repr__

    def to_dict(self):
        return(dict(self))

    def to_nltk_tree(self):
        try:
            return( nlp_tree_to_nltk_tree(dict(self)) )
        except:
            warn("nltk package coulnd't be loaded", ImportWarning)
            return( self )

def new_tree(x):
    return tree(x)

def is_nltk_tree(x):
    try:
        return isinstance(x, nltkTree)
    except:
        return False

def new_python_object(x, type):
    if ( type == 1 ):
        if PythonInR_FLAGS['useNltkTree']:
            return tree(x).to_nltk_tree()
        else:
            return tree(x)

def to_r(x, autotype):
    print("to_r")
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
            return( data_frame(x.to_dict(), list(x.index), list(x.keys()), df.shape, None) )
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

## TODO: add NA, NaN, Inf
class NA_int(int):
    """A Typed tuple Class"""
    def __new__(self, value):
        self.value = value
        return int.__new__(self, value)
        
## z = NA_int(3)
## z

def is_scalar(x):
    if x is None:
        return True
    return isinstance(x, (bool, int, long, float, bytes, unicode))

def is_pandas_data_frame(x):
    try:
        return isinstance(x, pd.DataFrame)
    except:
        return False

def is_dict(x):
    return isinstance(x, dict)

def is_list(x):
    return isinstance(x, list)

def is_tuple(x):
    return isinstance(x, tuple)

"""
100  vector
    110  scalar
    120  tlist
    130  ttuple
    140  numpy
200  matrix
    210  list                 #TODO! (sollte ich wegnehmen da matrix jetzt eh liste!)
    220  numpy
    230  cvxopt
300  array
    310  numpy
400  list
    410  tree
    420  slam
        421  cvxopt
        422  bsr
        423  coo
        424  csc
        425  csr
        426  dia
        427  dok
        428  lil
    430  nlist (dict)
500  data.frame
    510  pandas
600  environments            #TODO! (actually I don't know if this is needed!)
700  PythonInR Object
"""
def get_container_type(x):
    if is_vector(x):
        return 100
    if is_tlist(x):
        return 120
    if is_ttuple(x):
        return 130
    if is_numpy_vector(x):
        return 140
    if is_matrix(x):
        return 200
    if is_numpy_matrix(x):
        return 210
    if is_cvxopt_matrix(x):
        return 220
    if is_array(x):
        return 300
    if is_numpy_array(x):
        return 310
    if is_data_frame(x):
        return 500
    if is_pandas_data_frame(x):
        return 510
    if is_nltk_tree(x):
        return 410
    if is_simple_triplet_matrix(x):
        return 420
    if is_cvxopt_sparse_matrix(x):
        return 421
    if is_bsr_matrix(x):
        return 422
    if is_coo_matrix(x):
        return 423
    if is_csc_matrix(x):
        return 424
    if is_csr_matrix(x):
        return 425
    if is_dia_matrix(x):
        return 426
    if is_dok_matrix(x):
        return 427
    if is_lil_matrix(x):
        return 428
    if is_dict(x):
        return 430
    if is_list(x):
        return 400
    if is_tuple(x):
        return 401
    return 700
