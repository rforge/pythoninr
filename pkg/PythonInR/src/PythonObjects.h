/* --------------------------------------------------------------------------  \

    PythonObjects

    Provides functions cast R objects into Python objects!

\  -------------------------------------------------------------------------- */

#ifndef PythonObjects
#define PythonObjects

#include "PythonInR.h"
#include "CastRObjects.h"
#include "R_Run_Fun.h"

PyObject *r_to_py_vector(SEXP names, SEXP r_object);
PyObject *r_to_py_matrix(SEXP r_object);
PyObject *r_to_py_array(SEXP r_object);
PyObject *r_to_py_dataFrame(SEXP r_object);
PyObject *r_to_py_tree(SEXP r_object);
PyObject *r_slam_to_py_sparse(SEXP r_object, int type);

#endif
