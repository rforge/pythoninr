/* --------------------------------------------------------------------------  \

    R-Utility Function

\  -------------------------------------------------------------------------- */

#include "Py_Utility.h"

/*  ----------------------------------------------------------------------------

    Py_GetR_Type 
      returns the integer which is needed for R vector allocation

  ----------------------------------------------------------------------------*/
int Py_GetR_Type(PyObject *py_object){
    int r_type = -1;

    if ( PyNone_Check(py_object) ){
        r_type = 0;  /** NULL **/
    }else if ( PyBool_Check(py_object) ){
        r_type = 10; /** logical **/
    }else if ( PyInt_Check(py_object) ){
        r_type = 13; /** integer + th.int **/ // NOTE: 12 is not used any more in R
    }else if ( PyLong_Check(py_object) ){
        r_type = 13; /** integer **/
    }else if ( PyFloat_Check(py_object) ){
        r_type = 14; /** double **/
    }else if ( PyString_Check(py_object) ){
        r_type = 16; /** character + th.string **/
    }else if ( PyUnicode_Check(py_object) ){
        r_type = 16; /** character **/ // NOTE: 17 is the dot-dot-dot object in R
    }
    return r_type;
}

int py_get_container_type(PyObject *o) {
	Py_XINCREF(o); // NOTE: GET_CONTAINER_TYPE reduces refcount (-1) therefore incref it before
    PyObject *py_type = GET_CONTAINER_TYPE(o);
    int type = PY_TO_C_INTEGER(py_type);
    Py_XDECREF(py_type);
    return type;
}

SEXP test_get_container_type(SEXP name) {
	PyObject *pyo = py_get_py_obj(R_TO_C_STRING(name));
	return c_to_r_integer(py_get_container_type(pyo));
}
