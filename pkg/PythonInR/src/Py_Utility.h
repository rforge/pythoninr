/* --------------------------------------------------------------------------  \

    R-Utility Function

\  -------------------------------------------------------------------------- */

#ifndef PYTHON_IN_PY_Utility
#define PYTHON_IN_PY_Utility

#include "PythonInR.h"
#include "PyTypeDefinitions.h"

int Py_GetR_Type(PyObject *py_object);

int py_get_container_type(PyObject *o);

SEXP Test_Py_GetContainer_Type(SEXP name);

SEXP test_get_container_type(SEXP x);

#endif
