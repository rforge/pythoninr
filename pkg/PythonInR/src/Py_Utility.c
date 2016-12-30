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

int py_get_container_type_old(PyObject *o) {
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

int Py_Type_Check(PyObject *py_object, const char *py_type) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, py_type) == 0);
}

int numpy_shape_len(PyObject *o) {
	PyObject *shape = PyObject_GetAttrString(o, "shape");
	PyObject *py_len = PyLong_FromSsize_t(PyTuple_GET_SIZE(shape));
	Py_XDECREF(shape);
    int tuple_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);
    return tuple_len;
}

int py_get_container_type(PyObject *o) {
    int type=700;
    if ( PyList_Check(o) ) {
		if ( Py_Type_Check(o, "PythonInR.vector") ) return 100;
		if ( Py_Type_Check(o, "PythonInR.matrix") ) return 200;
		if ( Py_Type_Check(o, "PythonInR.array" ) ) return 300;
		if ( Py_Type_Check(o, "PythonInR.tlist" ) ) return 120;
		// NLTK	
		// from nltk.tree import Tree as nltkTree
		if ( IS_NLTK_TREE(o) ) return 410;
		return 400; // 150  List of List 210
	} 
	
	if ( PyTuple_Check(o) ) {
		if ( Py_Type_Check(o, "PythonInR.ttuple") ) return 130;
		return 401; // 160
	}

    if ( IS_SCIPY_MATRIX(o) ) {
        if ( Py_Type_Check(o, "bsr_matrix") ) return 422;
        if ( Py_Type_Check(o, "coo_matrix") ) return 423;
        if ( Py_Type_Check(o, "csc_matrix") ) return 424;
        if ( Py_Type_Check(o, "csr_matrix") ) return 425;
        if ( Py_Type_Check(o, "dia_matrix") ) return 426;
        if ( Py_Type_Check(o, "dok_matrix") ) return 427;
        if ( Py_Type_Check(o, "lil_matrix") ) return 428;
    }
	
	if ( PyDict_Check(o) ) {
		if ( Py_Type_Check(o, "PythonInR.simple_triplet_matrix" ) ) return 420;
		if ( Py_Type_Check(o, "PythonInR.data_frame" ) ) return 500;
		// TODO: Tree
		return 430; // TODO: let simple_triple_matrix inherit from dict.
	} 
	
	if ( IS_NUMPY_ARRAY(o) ) {
		if ( numpy_shape_len(o) <= 1 ) return 140;
		if ( numpy_shape_len(o) == 2 ) return 220;
		return 310;
	} 
	
	if ( Py_Type_Check(o, "cvxopt.base.matrix") ) return 230;
	if ( Py_Type_Check(o, "cvxopt.base.spmatrix") ) return 421;
	
	if ( Py_Type_Check(o, "DataFrame") ) return 510;
		
	// Rprintf("type: %i\n", type);
	// Rprintf("type_name: %s\n", Py_TYPE(o)->tp_name);
	// Rprintf("module_name: %s\n", Py_TYPE(o)->m_name);
    return type;
}

/**

SEXP py_to_r__(PyObject *py_object, int simplify, int autotype) {
    SEXP r_val;
    int r_type;
       
    if ( PyNone_Check(py_object) ) {                                            // None
        r_val = R_NilValue;


    } else if ( PyTuple_Check(py_object) & autotype ) {                         // Tuple
        if (simplify){
           r_type = PyTuple_AllSameType(py_object);
           if ( r_type > -1 ){  
               r_val = py_tuple_to_r_vec(py_object, r_type);
           } else {
               r_val = py_tuple_to_r_list(py_object, simplify);
           }
        } else {
        r_val = py_tuple_to_r_list(py_object, simplify);
        }
    } else if ( PyList_Check(py_object) & autotype ) {                          // List
        // Rprintf("py_to_r.list\n");
        if ( Py_Vector_Check(py_object) & autotype ) {
            // Rprintf("py_to_r.vector\n");
            r_val = py_vector_to_r_vec(py_object);                              // vector
        } else if ( Py_Matrix_Check(py_object) & autotype ) {
            r_val = py_matrix_to_r_matrix(py_object);                           // matrix
        } else if ( Py_Tree_Check(py_object) & use_PY_To_R_Typecast ) {
            // TODO: check RefCount!
            py_object = py_to_r_typecast(py_object, 1);
            // the above returns a dict therfore restart!
            r_val = py_dict_to_r_list(py_object, simplify);
        } else if (simplify){
            r_type = PyList_AllSameType(py_object);
            if ( r_type > -1 ){
                r_val = py_list_to_r_vec(py_object, r_type);
            } else if ( r_type == -2 ) {
                // TODO: I should handle 0 objects based on their Python type!
                r_val = py_list_to_r_list(py_object, simplify);
            } else{
                r_val = py_list_to_r_list(py_object, simplify);
            }
        } else {
            r_val = py_list_to_r_list(py_object, simplify);
        }
    } else if ( PyDict_Check(py_object) & autotype ){                           // Dict     
        if (simplify){
            r_type = PyDict_AllSameType(py_object);
            if ( r_type > -1 ){
                r_val = py_dict_to_r_vec(py_object, r_type);
            }else{
              r_val = py_dict_to_r_list(py_object, simplify);
            }
        }else{
            r_val = py_dict_to_r_list(py_object, simplify);
        }
    } else if ( Py_Array_Check(py_object) & autotype ) {
        r_val = py_array_to_r_array(py_object);                                 // array
        
    } else if ( Py_Slam_Check(py_object) & autotype ) {
        r_val = py_slam_to_r_slam(py_object);
        
    } else if ( Py_DataFrame_Check(py_object) & autotype ) {
        r_val = py_df_to_r_df(py_object);
        
    } else if ( Py_Error_Check(py_object) ) {
        r_val = py_error_to_r_error(py_object);
    
    } else {
        // Rprintf("NO type found!\n");
        py_object = py_to_r_typecast(py_object, autotype);
        r_val = py_to_r(py_object, simplify, autotype);
    }
    
    return r_val;
}
 **/
