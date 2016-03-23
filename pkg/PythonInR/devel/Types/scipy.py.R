exit()
python

import scipy.sparse as sp
import os
os.chdir("/home/florian/Bitbucket/Python_R_Interface/PythonInR/inst/python")
import R as __R__
##from R import simple_triplet_matrix
import numpy as np


A = sp.csr_matrix([[1, 2, 0], [0, 0, 3], [4, 0, 5]])
A

__R__.scipy_sparse_to_slam(A)

__R__.toR(A.tobsr(), 1)
scipy_sparse_to_slam(A.tobsr())

A.tocoo()
scipy_sparse_to_slam(A.tocoo())

A.tocsc()
scipy_sparse_to_slam(A.tocsc())

sp.isspmatrix(A.todense())
A.todense().tolist()

A.todia()
scipy_sparse_to_slam(A.todia())

A.todok()
scipy_sparse_to_slam(A.todok())

A.tolil()
scipy_sparse_to_slam(A.tolil())

## Convert
B = A.tocoo()
dir(B)
B.col
list(B.row)
list(B.data)
B.shape

x = B
dir(sp)

sp.issparse(B)
sp.isspmatrix(B)

def is_simple_triplet_matrix(x):
    type(x).__name__ == "PythonInR.simple_triplet_matrix"

is_simple_triplet_matrix()

def scipy_sparse_to_slam(x):
    if ( sp.isspmatrix_coo(x) ):
        return( simple_triplet_matrix(list(x.row), list(x.col), list(x.data), 
            x.shape[0], x.shape[1], None,  x.data.dtype).toR() )
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




'issparse', 'isspmatrix', 'isspmatrix_bsr', 'isspmatrix_coo', 'isspmatrix_csc', 'isspmatrix_csr', 
'isspmatrix_dia', 'isspmatrix_dok', 'isspmatrix_lil', 



['SparseEfficiencyWarning', 'SparseWarning', 'Tester', '__all__', '__builtins__', '__doc__', 
'__file__', '__name__', '__package__', '__path__', '_csparsetools', '_sparsetools', 
'absolute_import', 'base', 'bench', 'block_diag', 'bmat', 'bsr', 'bsr_matrix', 'compressed', 
'construct', 'coo', 'coo_matrix', 'cs_graph_components', 'csc', 'csc_matrix', 'csgraph', 
'csr', 'csr_matrix', 'data', 'dia', 'dia_matrix', 'diags', 'division', 'dok', 'dok_matrix', 
'extract', 'eye', 'find', 'hstack', 'identity', 

'issparse', 'isspmatrix', 'isspmatrix_bsr', 'isspmatrix_coo', 'isspmatrix_csc', 'isspmatrix_csr', 
'isspmatrix_dia', 'isspmatrix_dok', 'isspmatrix_lil', 

'kron', 'kronsum', 'lil', 'lil_matrix', 'print_function', 'rand', 'random', 's', 
'spdiags', 'spfuncs', 'spmatrix', 'sputils', 'test', 'tril', 'triu', 'vstack']
