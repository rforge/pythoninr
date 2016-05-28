/* --------------------------------------------------------------------------  \

    Create - Constructor Functions for the New Python Objects

\  -------------------------------------------------------------------------- */
#ifndef PYTHON_IN_R_PY_TYPE
#define PYTHON_IN_R_PY_TYPE
 
#include "PythonInR.h"

/*  ----------------------------------------------------------------------------
    PY_VEC.* 
    
    Creates a new object of type PyVector.
    :param PyObject x: an interable (noramlly list) giving the values
    :param PyObject y: an list giving the list
    :return: A new PyVector
    :rtype: PyVector
  ----------------------------------------------------------------------------*/ 
// x ... values    y ... names
#define PY_VEC_BOOL(x, y)    Py_call_2_args("__R__.vec_bool", x, y)
#define PY_VEC_INT(x, y)     Py_call_2_args("__R__.vec_int", x, y)
#define PY_VEC_LONG(x, y)    Py_call_2_args("__R__.vec_long", x, y)
#define PY_VEC_FLOAT(x, y)   Py_call_2_args("__R__.vec_float", x, y)
#define PY_VEC_STRING(x, y)  Py_call_2_args("__R__.vec_string", x, y)
#define PY_VEC_UNICODE(x, y) Py_call_2_args("__R__.vec_unicode", x, y)

// x ... values    y ... dim    z ... dimnames
#define PY_MATRIX_BOOL(x, y, z)    Py_call_3_args("__R__.matrix_bool", x, y, z)
#define PY_MATRIX_INT(x, y, z)     Py_call_3_args("__R__.matrix_int", x, y, z)
#define PY_MATRIX_LONG(x, y, z)    Py_call_3_args("__R__.matrix_long", x, y, z)
#define PY_MATRIX_FLOAT(x, y, z)   Py_call_3_args("__R__.matrix_float", x, y, z)
#define PY_MATRIX_STRING(x, y, z)  Py_call_3_args("__R__.matrix_string", x, y, z)
#define PY_MATRIX_UNICODE(x, y, z) Py_call_3_args("__R__.matrix_unicode", x, y, z)
#define PY_MATRIX_LIST(x, y, z)    Py_call_3_args("__R__.matrix_list", x, y, z)

#define PY_MATRIX_TO_NUMPY(x)  Py_call_1_arg("__R__.matrix_to_numpy", x)
#define PY_MATRIX_TO_CVXOPT(x) Py_call_1_arg("__R__.matrix_to_cvxopt", x)

#define PY_STM_FROM_DICT(x) Py_call_1_arg("__R__.simple_triplet_matrix_from_dict", x)
#define PY_STM_TO_CVXOPT(x) PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_cvxopt_sparse_matrix", "")
#define PY_STM_TO_BSR(x)    PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_bsr", "")
#define PY_STM_TO_COO(x)    PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_coo", "")
#define PY_STM_TO_CSC(x)    PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_csc", "")
#define PY_STM_TO_CSR(x)    PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_csr", "")
#define PY_STM_TO_DENSE(x)  PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_dense", "")
#define PY_STM_TO_DIA(x)    PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_dia", "")
#define PY_STM_TO_DOK(x)    PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_dok", "")
#define PY_STM_TO_LIL(x)    PyObject_CallMethod(r_to_py_simple_triplet_matrix(x), "to_lil", "")

// a ... data_frame    b ... rownames    c ... colnames    d ... dim
#define PY_DATA_FRAME(a, b, c, d) Py_call_4_args("__R__.new_data_frame", a, b, c, d)

// a ... data    b ... dim    c ... dimnames    d ... dtype
#define PY_ARRAY(a, b, c, d) Py_call_4_args("__R__.new_array", a, b, c, d)
#define PY_ARRAY_TO_NUMPY(x) PyObject_CallMethod(x, "to_numpy", "")


#define PY_TREE(x)    Py_call_1_arg("__R__.new_tree", x)

#define PY_TLIST_BOOL(x)    Py_call_1_arg("__R__.tlist_bool", x)
#define PY_TLIST_INT(x)     Py_call_1_arg("__R__.tlist_int", x)
#define PY_TLIST_LONG(x)    Py_call_1_arg("__R__.tlist_long", x)
#define PY_TLIST_FLOAT(x)   Py_call_1_arg("__R__.tlist_float", x)
#define PY_TLIST_STRING(x)  Py_call_1_arg("__R__.tlist_string", x)
#define PY_TLIST_UNICODE(x) Py_call_1_arg("__R__.tlist_unicode", x)

#define PY_TTUPLE_BOOL(x)    Py_call_1_arg("__R__.ttuple_bool", x)
#define PY_TTUPLE_INT(x)     Py_call_1_arg("__R__.ttuple_int", x)
#define PY_TTUPLE_LONG(x)    Py_call_1_arg("__R__.ttuple_long", x)
#define PY_TTUPLE_FLOAT(x)   Py_call_1_arg("__R__.ttuple_float", x)
#define PY_TTUPLE_STRING(x)  Py_call_1_arg("__R__.ttuple_string", x)
#define PY_TTUPLE_UNICODE(x) Py_call_1_arg("__R__.ttuple_unicode", x)

#define PY_VEC_TO_NUMPY_ARRAY(x)   Py_call_1_arg("__R__.numpy_array", x)

PyObject *Py_Vec(PyObject *py_li, PyObject *py_names, int r_type);
PyObject *Py_Matrix(PyObject *py_li, PyObject *py_dim, PyObject *py_dimnames, int r_type);
PyObject *Py_Tlist(PyObject *py_li, int r_type);
PyObject *Py_Ttuple(PyObject *py_li, int r_type);

#define PyVec_Check(x)        Py_call_1_arg("__R__.is_vector", x)
#define PyVecBool_Check(x)    Py_call_1_arg("__R__.is_vector_bool", x)
#define PyVecInt_Check(x)     Py_call_1_arg("__R__.is_vector_int", x)
#define PyVecLong_Check(x)    Py_call_1_arg("__R__.is_vector_long", x)
#define PyVecFloat_Check(x)   Py_call_1_arg("__R__.is_vector_float", x)
#define PyVecString_Check(x)  Py_call_1_arg("__R__.is_vector_string", x)
#define PyVecUnicode_Check(x) Py_call_1_arg("__R__.is_vector_unicode", x)

#define GET_CONTAINER_TYPE(x) Py_call_1_arg("__R__.get_container_type", x)
   
#endif
