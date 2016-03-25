/* --------------------------------------------------------------------------  \

    GetPyObjects

    Provides function to get Python objects from various name spaces.

\  -------------------------------------------------------------------------- */

#ifndef CAST_PY_OBJECTS
#define CAST_PY_OBJECTS

#include "PythonInR.h"
#include "R_Run_String.h"
#include "CToR.h"
#include "Py_Utility.h"

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
