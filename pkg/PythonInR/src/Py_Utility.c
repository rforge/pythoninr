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
        r_type = 12; /** integer + th.int **/ // NOTE: 12 is not used any more in R
    }else if ( PyLong_Check(py_object) ){
        r_type = 13; /** integer **/
    }else if ( PyFloat_Check(py_object) ){
        r_type = 14; /** double **/
    }else if ( PyString_Check(py_object) ){
        r_type = 16; /** character + th.string **/
    }else if ( PyUnicode_Check(py_object) ){
        r_type = 17; /** character **/ // NOTE: 17 is the dot-dot-dot object in R
    }
    return r_type;
}

int Py_GetContainer_Type(PyObject *o) {
	int container = -1;
	
	int scalar = Py_GetR_Type(o);
	if ( scalar > 0 ) return scalar;
	
	if ( PyList_Check(o) ) {
		if ( PyList_CheckExact(o) ) return 400; /** A Plain List **/
		if ( PyVec_Check(o) ) return 100; /** A sub-type from List called vector **/
		if ( PyTypedList_Check(o) ) return 120; 
		if ( PyTypedTuple_Check(o) ) return 130; 
	}
	
	return container;
}

/**
		} else if ( isVector(x) ) {
			if ( (GET_LENGTH(x) == 1) & !HAS_TH_CONTAINER(x) ) return 110; /  Scalar /
			if ( HAS_TH_LIST(x) )  return 120; / ** Vector + th.list ** /
			if ( HAS_TH_TUPLE(x) ) return 130; / ** Vector + th.tuple ** /
			if ( HAS_TH_NUMPY(x) ) return 140; / ** Vector + th.numpy ** /
			return 100; / ** Vector ** /
		}
**/

SEXP Test_Py_GetContainer_Type(SEXP name) {
	PyObject *pyo = py_get_py_obj(R_TO_C_STRING(name));
	int container = Py_GetContainer_Type(pyo);
	return c_to_r_integer(container);
}
