/* --------------------------------------------------------------------------  \

    CastRObjects

    Provides functions cast R objects into Python objects!

\  -------------------------------------------------------------------------- */

#ifndef CAST_R_OBJECTS
#define CAST_R_OBJECTS

#include "PythonInR.h"
#include "CToR.h"
#include "R_Run_String.h"
#include "PythonObjects.h"

int has_typehint(SEXP x, const char *type);

PyObject *r_logical_to_py_boolean(SEXP r_object);

PyObject *r_integer_to_py_long(SEXP r_object);

PyObject *r_numeric_to_py_double(SEXP r_object);

PyObject *r_character_to_py_string(SEXP r_object);

PyObject *r_character_to_py_unicode(SEXP r_object);

PyObject *r_to_py_primitive(SEXP r_object);

PyObject *r_to_py_tuple(SEXP r_object);

PyObject *r_to_py_list(SEXP r_object);

PyObject *r_matrix_to_py_list(SEXP r_object);

PyObject *r_to_py_dict(SEXP keys, SEXP value);

const char *get_class_name_vec(SEXP x, int len);

const char *get_class_name(SEXP x);

int isPyInR_PyObject(SEXP x);

int compare_r_class(SEXP x, const char *className);

const char *r_get_py_object_location(SEXP x);

SEXP r_to_py_preprocessing_class(SEXP x, const char *cls);

SEXP r_to_py_preprocessing(SEXP x);

PyObject *r_to_py(SEXP r_object);

#endif
