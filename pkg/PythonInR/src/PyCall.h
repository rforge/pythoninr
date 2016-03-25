/* --------------------------------------------------------------------------  \

    PyCall

    Provides a function to call Python methods from R.

\  -------------------------------------------------------------------------- */

#include "PythonInR.h"
#include "CastRObjects.h"
#include "CastPyObjects.h"
#include "GetPyObjects.h"
#include "CToR.h"

SEXP py_call_obj(SEXP r_obj_name, SEXP r_args, SEXP r_kw, SEXP simplify, SEXP auto_typecast);

PyObject *python_call(const char *c_obj_name, PyObject *py_args, PyObject *py_kw);

PyObject *Python_error(const char *message, const char *domain, const char *error_type);

SEXP Test_Python_error(SEXP message);

PyObject *Py_call_1_arg(const char *c_obj_name, PyObject *x);

SEXP Test_Py_call_1_arg(SEXP fun_name, SEXP arg);

PyObject *Py_call_2_args(const char *c_obj_name, PyObject *x, PyObject *y);
