/* --------------------------------------------------------------------------  \

    PythonObjects

    Provides functions create new PythonObjects!

\  -------------------------------------------------------------------------- */

#include "PythonObjects.h"
#include "CastRObjects.h"
#include "PyCall.h"
#include "PythonInR.h"

SEXP combine_character(SEXP x, SEXP y) {
	SEXP r_vec;
	int vec_len;
	if ( isNull(y) ) return(x);
	if ( isNull(x) ) return(y);
	vec_len = GET_LENGTH(x) + GET_LENGTH(y);
	// CHARSXP      9 
	PROTECT(r_vec = allocVector(STRSXP, vec_len));
	for (int i=0; i < GET_LENGTH(x); i++){
		SET_STRING_ELT(r_vec, i, STRING_ELT(x, 0));
    }
    for (int i=0; i < GET_LENGTH(y); i++){
		SET_STRING_ELT(r_vec, GET_LENGTH(x)+i, STRING_ELT(y, 0));
    }
    UNPROTECT(1);
    return(r_vec);
}

SEXP r_get_class_name(SEXP x) {
	SEXP klass = GET_CLASS(x);
	if ( isNull( klass )  ) {
		if ( IS_LOGICAL(x)   ) klass = c_to_r_string("logical");
		if ( IS_INTEGER(x)   ) klass = c_to_r_string("integer");
		if ( IS_NUMERIC(x)   ) klass = c_to_r_string("numeric");
		if ( IS_CHARACTER(x) ) klass = c_to_r_string("character");
		if ( isComplex(x)    ) klass = c_to_r_string("complex");
	} 
	if ( isArray(x) & !isMatrix(x) ) {
		klass = combine_character(c_to_r_string("array"), klass);
	} else if ( isMatrix(x) ){
		klass = combine_character(c_to_r_string("matrix"), klass);
	}
	return( klass );
}

/*  ----------------------------------------------------------------------------

    r_to_py_vector

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_vector(SEXP names, SEXP r_object) {
	PyObject *new_obj = py_get_py_obj("__R__.vector([], None, 'integer')");
	
	PyObject_SetAttrString(new_obj, "values", r_to_py_list(r_object) ); 
	if ( GET_LENGTH(names) > 0 ) {
		PyObject_SetAttrString(new_obj, "names", r_to_py_list(names) ); 
	} else {
		PyObject_SetAttrString(new_obj, "names", PY_NONE ); 
	}
	SEXP klass = r_get_class_name(r_object);
	PyObject_SetAttrString(new_obj, "dtype", r_to_py(klass) ); 
	
	if ( has_typehint(r_object, "dict") ) {
		PyObject *dict =  PyObject_CallMethod(new_obj, "toDict", "");
		return(dict);
	} 
	
	return(new_obj);
}

/*  ----------------------------------------------------------------------------

    r_to_py_matrix

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_matrix(SEXP r_object) {
	PyObject *new_obj = py_get_py_obj("__R__.matrix([], [], [], (0,0), 'integer')");
	
	PyObject_SetAttrString(new_obj, "values", r_matrix_to_py_list(r_object) ); 
	if ( GET_LENGTH(GET_ROWNAMES(GET_DIMNAMES(r_object))) > 0 ) {
		PyObject_SetAttrString(new_obj, "rownames", r_to_py_list(GET_ROWNAMES(GET_DIMNAMES(r_object))) ); 
	} else {
		PyObject_SetAttrString(new_obj, "rownames", PY_NONE ); 
	}
	if ( GET_LENGTH(GET_COLNAMES(GET_DIMNAMES(r_object))) > 0 ) {
		PyObject_SetAttrString(new_obj, "colnames", r_to_py_list(GET_COLNAMES(GET_DIMNAMES(r_object))) ); 
	} else {
		PyObject_SetAttrString(new_obj, "colnames", PY_NONE ); 
	}
	SEXP klass = r_get_class_name(r_object);
	
	PyObject_SetAttrString(new_obj, "dim", r_to_py_tuple(GET_DIM(r_object)) );
	PyObject_SetAttrString(new_obj, "dtype", ( isNull(klass) ) ? PY_NONE : r_to_py_list(klass) );
	
	if ( has_typehint(r_object, "numpyMatrix") ) {
		PyObject *numpy_matrix =  PyObject_CallMethod(new_obj, "toNumpyMatrix", "");
		return(numpy_matrix);
	} else if ( has_typehint(r_object, "numpyArray") ) {
		PyObject *numpy_matrix =  PyObject_CallMethod(new_obj, "toNumpyArray", "");
		return(numpy_matrix);
	} else if ( has_typehint(r_object, "cvxoptMatrix") ) {
		PyObject *numpy_matrix =  PyObject_CallMethod(new_obj, "toCvxOptMatrix", "");
		return(numpy_matrix);
	}
	
	return(new_obj);
}

/**
SEXP r_array_to_numpy_array(SEXP robject) {
    SEXP fun, r_obj, e, nsp;
    int hadError;
    
	PROTECT(nsp = eval( lang2( install("getNamespace"), 
	                    ScalarString(mkChar("PythonInR")) ), R_GlobalEnv)); 
    
    PROTECT(e = allocVector(LANGSXP, 2));
    fun = findFun(install("r_array_to_numpy_array"), nsp);
    if(fun == R_NilValue) {
		fprintf(stderr, "No definition for function foo. Source foo.R and save the session.\n");
		UNPROTECT(2);
		exit(1);
    }
    
    SETCAR(e, fun);

    SETCADR(e, robject);
    SET_TAG(CDR(e), install("x"	));
    r_obj = R_tryEval(e, NULL, &hadError);
    
    if (hadError){
		Rprintf("an error occurred at the transformation from numpy to R\n");
	}
	UNPROTECT(2);
	return(r_obj);
}


SEXP R_call_function_ft(SEXP namespace, const char * fun_name, SEXP kwargs) {
    SEXP fun, r_obj, e;
    int hadError;
     
    PROTECT(e = allocVector(LANGSXP, 2));
    fun = findFun(install("r_array_to_numpy_array"), namespace);
    if(fun == R_NilValue) {
		fprintf(stderr, "No definition for function foo. Source foo.R and save the session.\n");
		UNPROTECT(2);
		exit(1);
    }
    
    SETCAR(e, fun);

    SETCADR(e, robject);
    SET_TAG(CDR(e), install("x"	));
    r_obj = R_tryEval(e, NULL, &hadError);
    
    if (hadError){
		Rprintf("an error occurred at the transformation from numpy to R\n");
	}
	UNPROTECT(2);
	return(r_obj);
}
**/

/*  ----------------------------------------------------------------------------

    r_to_py_array

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_array(SEXP r_object) {	
	PyObject *new_obj = py_get_py_obj("__R__.array([], [], (), [])");
	int tmp = r_vec_to_list_flag;
	r_vec_to_list_flag = 1;
	PyObject_SetAttrString(new_obj, "values", r_to_py_list(r_to_py_preprocessing_class(r_object, "array")) ); 
	
	if ( GET_LENGTH(GET_ROWNAMES(GET_DIMNAMES(r_object))) > 0 ) {
		PyObject_SetAttrString(new_obj, "dimnames", r_to_py_list(GET_DIMNAMES(r_object)) ); 
	} else {
		PyObject_SetAttrString(new_obj, "dimnames", PY_NONE ); 
	}
	PyObject_SetAttrString(new_obj, "dim", r_to_py_tuple(GET_DIM(r_object)) );
	SEXP klass = r_get_class_name(r_object);
	PyObject_SetAttrString(new_obj, "dtype", ( isNull(klass) ) ? PY_NONE : r_to_py_list(klass) );
	r_vec_to_list_flag = tmp;
	
	if ( has_typehint(r_object, "numpyArray") ) {
		PyObject *numpy_matrix =  PyObject_CallMethod(new_obj, "toNumpyArray", "");
		return(numpy_matrix);
	}
		
	return(new_obj);
}

/*  ----------------------------------------------------------------------------

    r_to_py_dataFrame

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_dataFrame(SEXP r_object) {
	PyObject *new_obj = py_get_py_obj("__R__.dataFrame({}, [], [], (), [])");
	int tmp = r_vec_to_list_flag;
	r_vec_to_list_flag = 1; // NOTE: Since the elements of a data.frame can be of type vector and list 
	                        //       I typecast everything to a list.
	                        
	SEXP names = GET_NAMES(r_object);
	PyObject_SetAttrString(new_obj, "values", r_to_py_dict(names, r_object) ); 
	
	if ( GET_LENGTH(GET_ROWNAMES(GET_DIMNAMES(r_object))) > 0 ) {
		PyObject_SetAttrString(new_obj, "rownames", r_to_py_list(GET_ROWNAMES(GET_DIMNAMES(r_object))) ); 
	} else {
		PyObject_SetAttrString(new_obj, "rownames", PY_NONE ); 
	}
	if ( GET_LENGTH(GET_COLNAMES(GET_DIMNAMES(r_object))) > 0 ) {
		PyObject_SetAttrString(new_obj, "colnames", r_to_py_list(names) ); 
	} else {
		PyObject_SetAttrString(new_obj, "colnames", PY_NONE ); 
	}
	SEXP klass = r_get_class_name(r_object);
	
	PyObject_SetAttrString(new_obj, "dim", r_to_py(R_fun_dim(r_object)) );
	PyObject_SetAttrString(new_obj, "dtype", ( isNull(klass) ) ? PY_NONE : r_to_py_list(klass) );
	
	r_vec_to_list_flag = tmp;
	
	if ( has_typehint(r_object, "pandas") ) {
		PyObject *pandas_df =  PyObject_CallMethod(new_obj, "toPandas", "");
		return(pandas_df);
	}
	return(new_obj);
}

/*  ----------------------------------------------------------------------------

    r_to_py_Tree

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_tree(SEXP r_object) {
	PyObject *new_obj = py_get_py_obj("__R__.tree({})");
	PyObject *args = r_to_py_dict(GET_NAMES(r_object), r_object);
	PyObject_SetAttrString(new_obj, "tree", args);
	// TODO:  Py_XDECREF(args);
	PyObject *py_obj = PyObject_CallMethod(new_obj, "toNltkTree", "");
	// TODO: Py_XDECREF(new_obj);
	return( py_obj );
}

/*  ----------------------------------------------------------------------------

    r_slam_to_py_sparse

  ----------------------------------------------------------------------------*/
PyObject *r_slam_to_py_sparse(SEXP r_object, int type) {
	int tmp = r_vec_to_list_flag;
	r_vec_to_list_flag = 1;
	PyObject *new_obj = py_get_py_obj("__R__.simple_triplet_matrix([], [], [])");
	PyObject *args = r_to_py_dict(GET_NAMES(r_object), r_object);
	r_vec_to_list_flag = tmp;
	PyObject *method_name = Py_BuildValue("z", "fromDict");
	PyObject *py_rval = PyObject_CallMethodObjArgs(new_obj, method_name, args, NULL);
	if ( type == 1 ) {
		return( py_rval );
	} else if ( type == 2 ) {
		PyObject *new_obj = PyObject_CallMethod(py_rval, "toSciPySparseMatrix", "");
		return( new_obj );
	}
	return(py_rval);
}
