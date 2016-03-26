/* --------------------------------------------------------------------------  \

    R-Utility Function

\  -------------------------------------------------------------------------- */

#ifndef PYTHON_IN_PY_Utility
#define PYTHON_IN_PY_Utility

#include "PythonInR.h"
#include "PyTypeDefinitions.h"

int Py_GetR_Type(PyObject *py_object);

int Py_GetContainer_Type(PyObject *pyo);

SEXP Test_Py_GetContainer_Type(SEXP name);

#endif
