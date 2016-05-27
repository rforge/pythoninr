/* --------------------------------------------------------------------------  \

    CastRObjects

    Provides functions cast R objects into Python objects!

\  -------------------------------------------------------------------------- */

#ifndef CAST_R_OBJECTS
#define CAST_R_OBJECTS

#include "PythonInR.h"
#include "CToR.h"
#include "R_Run_String.h"
#include "R_Run_Fun.h"
#include "PythonObjects.h"
#include "R_Utility.h"

#define R_TO_PY_ITER(r, get, py, set) { for (long i = 0; i < len; i++) { item = get(r, i); set(py, i, item); } }

PyObject *r_logical_to_py_boolean(SEXP r_object);

PyObject *r_integer_to_py_long(SEXP r_object);

PyObject *r_numeric_to_py_double(SEXP r_object);

PyObject *r_character_to_py_string(SEXP r_object);

PyObject *r_character_to_py_unicode(SEXP r_object);

PyObject *r_to_py_scalar(SEXP r_object);

PyObject *r_to_py_vector(SEXP x);

PyObject *r_to_py_tlist(SEXP x);


PyObject *r_to_py_tuple(SEXP r_object);

PyObject *r_vec_to_py_list(SEXP ro);

PyObject *r_list_to_py_list(SEXP ro);

PyObject *r_to_py_list(SEXP ro);

PyObject *r_matrix_to_py_list(SEXP r_object);

PyObject *r_to_py_dict(SEXP keys, SEXP value);

const char *get_class_name_vec(SEXP x, int len);

const char *get_class_name(SEXP x);

int isPyInR_PyObject(SEXP x);

const char *r_get_py_object_location(SEXP x);

SEXP r_to_py_preprocessing_class(SEXP x, const char *cls);

SEXP r_to_py_preprocessing(SEXP x);

PyObject *r_to_py(SEXP r_object);

#endif
