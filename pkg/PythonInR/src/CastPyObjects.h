/* --------------------------------------------------------------------------  \

    GetPyObjects

    Provides function to get Python objects from various name spaces.

\  -------------------------------------------------------------------------- */

#ifndef CAST_PY_OBJECTS
#define CAST_PY_OBJECTS

#include "PythonInR.h"
#include "R_Run_String.h"
#include "R_Run_Fun.h"
#include "CToR.h"
#include "Py_Utility.h"

#define PY_TO_R__BOOL(o)    c_to_r_boolean(PY_TO_C_BOOLEAN(o))
#define PY_TO_R__INT(o)     c_to_r_integer(PY_TO_C_INTEGER(o))
#define PY_TO_R__LONG(o)    c_to_r_integer(PY_TO_C_LONG(o))
#define PY_TO_R__DOUBLE(o)  c_to_r_double(PY_TO_C_DOUBLE(o))
#define PY_TO_R__STRING(o)  c_to_r_string(PY_TO_C_STRING(o))
#define PY_TO_R__UNICODE(o) c_to_r_unicode(PY_TO_C_UNICODE(o))
#define PY_TO_R__VECTOR(o)  py_vector_to_r_vec(o)
#define PY_TO_R__TLIST(o)   py_tlist_to_r_vector(o)
#define PY_TO_R__TTUPLE(o)  py_ttuple_to_r_vector(o)
#define PY_TO_R__NUMPY_VECTOR(o) py_numpy_vector_to_r_vector(o)
#define PY_TO_R__MATRIX(o) py_matrix_to_r_matrix(o)
#define PY_TO_R__NUMPY_MATRIX(o) py_numpy_matrix_to_r_matrix(o)
#define PY_TO_R__CVXOPT_MATRIX(o) py_cvxopt_matrix_to_r_matrix(o)
#define PY_TO_R__ARRAY(o) R_NilValue
#define PY_TO_R__NUMPY_ARRAY(o) R_NilValue
#define PY_TO_R__LIST(o) py_list_to_r_list(o, 0)
#define PY_TO_R__TUPLE(o) py_tuple_to_r_list(o, 0)
#define PY_TO_R__NLTK_TREE(o) py_nltk_tree_to_nlp_tree(o)
#define PY_TO_R__SIMPLE_TRIPLET_MATRIX(o) py_stm_matrix_to_r_stm_matrix(o)
#define PY_TO_R__CVXOPT_SPARSE_MATRIX(o) R_NilValue
#define PY_TO_R__BSR(o) R_NilValue
#define PY_TO_R__COO(o) R_NilValue
#define PY_TO_R__CSC(o) R_NilValue
#define PY_TO_R__CSR(o) R_NilValue
#define PY_TO_R__DIA(o) R_NilValue
#define PY_TO_R__DOK(o) R_NilValue
#define PY_TO_R__LIL(o) R_NilValue
#define PY_TO_R__DICT(o) py_dict_to_r_list(o, 0)
#define PY_TO_R__DATA_FRAME(o) py_data_frame_to_r_data_frame(o)
#define PY_TO_R__PANDAS_DATA_FRAME(o) R_NilValue
#define PY_TO_R__OBJECT(o) R_NilValue
#define PY_TO_R__ERROR(o) py_error_to_r_error(o)

#define PY_NUMPY_VEC_TO_TLIST(x) Py_call_1_arg("__R__.numpy_vector_to_tlist", x)
#define PY_NUMPY_MATRIX_TO_DICT(x) Py_call_1_arg("__R__.numpy_matrix_to_dict", x)
#define PY_CVXOPT_MATRIX_TO_DICT(x) Py_call_1_arg("__R__.cvxopt_matrix_to_dict", x)
#define PY_NLTK_TREE_TO_DICT(x) Py_call_1_arg("__R__.nltk_tree_to_dict", x)


SEXP py_class(PyObject *py_object);

int PyList_AllSameType(PyObject *py_object);

int PyTuple_AllSameType(PyObject *py_object);

int PyDict_AllSameType(PyObject *py_object);

SEXP py_vec_to_r_vec(PyObject *py_keys, PyObject *py_values, int r_vector_type);

SEXP py_dict_to_r_vec(PyObject *py_object, int r_vector_type);

SEXP py_list_to_r_vec(PyObject *py_object, int r_vector_type);

SEXP py_tuple_to_r_vec(PyObject *py_object, int r_vector_type);

SEXP py_list_to_r_list(PyObject *py_object, int simplify);

SEXP py_tuple_to_r_list(PyObject *py_object, int simplify);

SEXP py_dict_to_r_list(PyObject *py_object, int simplify);

SEXP py_vector_to_r_vec(PyObject *py_object);

SEXP py_matrix_to_r_matrix(PyObject *obj);

SEXP py_array_to_r_array(PyObject *obj);

SEXP py_slam_to_r_slam(PyObject *obj);

SEXP py_df_to_r_df(PyObject *obj);

SEXP py_error_to_r_error(PyObject *obj);

int py_to_c_integer(PyObject *py_object);

const char *py_to_c_string(PyObject *py_object);

PyObject *py_to_r_typecast(PyObject *py_object, int autotype);

SEXP py_to_r_postprocessing(SEXP x, const char *cls);

SEXP py_to_r(PyObject *py_object, int simplify, int autotype);

#endif
