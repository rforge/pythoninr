/* --------------------------------------------------------------------------  \

    CastRObjects

    Provides functions cast R objects into Python objects!

\  -------------------------------------------------------------------------- */

#include "CastRObjects.h"
#include "PythonInR.h"



/*  ----------------------------------------------------------------------------

    r_logical_to_py_boolean 

  ----------------------------------------------------------------------------*/
PyObject *r_logical_to_py_boolean(SEXP r_object){
    PyObject *py_object;
    if( IS_LOGICAL(r_object) ){
        py_object = R_TO_PY_BOOLEAN(r_object);
    } else{
        error("r_logical_to_py_boolean the provided variable has not type logical!");
    }
    return py_object;
}

/*  ----------------------------------------------------------------------------

    r_integer_to_py_long 

  ----------------------------------------------------------------------------*/
PyObject *r_integer_to_py_long(SEXP r_object){
    PyObject *py_object;
    if( IS_INTEGER(r_object) ){
        py_object = R_TO_PY_LONG(r_object);
    } else{
        error("r_integer_to_py_long the provided variable has not type integer!");
    }
    return py_object;
}

/*  ----------------------------------------------------------------------------

    r_numeric_to_py_double 

  ----------------------------------------------------------------------------*/
PyObject *r_numeric_to_py_double(SEXP r_object){
    PyObject *py_object;
    if( IS_NUMERIC(r_object) ){
        py_object = R_TO_PY_DOUBLE(r_object);
    } else{
        error("r_numeric_to_py_double the provided variable has not type numeric!");
    }
    return py_object;
}

/*  ----------------------------------------------------------------------------

    r_character_to_py_string
      is byte string in python 3
  ----------------------------------------------------------------------------*/
PyObject *r_character_to_py_string(SEXP r_object){
    PyObject *py_object;
    if( IS_CHARACTER(r_object) ){
        py_object = R_TO_PY_STRING(r_object);
    } else{
        error("r_character_to_py_string the provided variable has not type character!");
    }
    return py_object;
}

/*  ----------------------------------------------------------------------------

    r_character_to_py_unicode

  ----------------------------------------------------------------------------*/
PyObject *r_character_to_py_unicode(SEXP r_object){
    PyObject *py_object;
    if( IS_CHARACTER(r_object) ){
        py_object = R_TO_PY_UNICODE(r_object);
    } else{
        error("r_character_to_py_unicode the provided variable has not type character!");
    }
    return py_object;
}

/*  ----------------------------------------------------------------------------

    r_to_py_scalar

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_scalar(SEXP r_object){
    PyObject *py_object;
    int r_type = r_GetR_Type(r_object);

    // Rprintf("r_to_py_scalar\n");
    
    if( r_type == 10 ) return R_TO_PY_BOOLEAN(r_object);
    if( r_type == 12 ) return R_TO_PY_INT(r_object);
    if( r_type == 13 ) return R_TO_PY_LONG(r_object); 
    if( r_type == 14 ) return R_TO_PY_DOUBLE(r_object);
    // (COMPLEX) if( r_type == 15 ) return R_TO_PY_INT(r_object);
    if( r_type == 16 ) return R_TO_PY_STRING(r_object);
    if( r_type == 17 ) return R_TO_PY_UNICODE(r_object);
    if( r_type == 11 ) return R_TO_PY_FACTOR(r_object);
    
    error("TypeError: r_to_py_scalar unkown data type!");
    return py_object;   
}

/*  ----------------------------------------------------------------------------

    r_to_py_vector

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_vector(SEXP x) {
    PyObject *py_names;
    SEXP names = GET_NAMES(x);
    PyObject *py_list  = r_vec_to_py_list(x);
    
    if ( GET_LENGTH(names) > 0 ) {
        py_names = r_vec_to_py_list(names);
    } else {
        py_names = PY_NONE; 
    }
    
    int r_type = r_GetR_Type(x);
    if ( r_type < 0 ) {
        error("ValueError: in r_to_py_vector expected vector got something else!");
    }
    if ( r_type == 11 ) {
        r_type = 17; // Since I transform factor to unicode
    }
    PyObject *pyo = Py_Vec(py_list, py_names, r_type);
    // TODO: Check Reference Counts! Should I decref py_list and py_names?
    
    ///if ( has_typehint(x, "dict") ) {
    /// PyObject *dict =  PyObject_CallMethod(pyo, "to_dict", "");
    /// return(dict);
    ///} 
    
    return(pyo);
}

/*  ----------------------------------------------------------------------------

    r_to_py_matrix

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_matrix(SEXP x) {
    PyObject *py_dimnames;
    if ( GET_LENGTH(GET_DIMNAMES(x)) > 0 ) {
        // Rprintf("r_to_py_matrix: len dimnames > 0!\n");
        py_dimnames = r_to_py(GET_DIMNAMES(x));
    } else {
        // Rprintf("r_to_py_matrix: len dimnames == 0!\n");
        py_dimnames = PY_NONE; 
    }
    PyObject *py_dim = r_to_py_tuple(GET_DIM(x));
    
    int r_type = IS_RAW(x) ? 24 : r_GetR_Type(x);
    if ( r_type < 0 ) {
        error("ValueError: in r_to_py_matrix unsupported type!");
    }

    PyObject *py_list = (r_type == 24) ? r_list_to_py_list(x) : r_vec_to_py_list(x);
    PyObject *pyo = Py_Matrix(py_list, py_dim, py_dimnames, r_type);
    // TODO: Check Reference Counts!
    return(pyo);
}

/*  ----------------------------------------------------------------------------

    r_to_py_array

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_array(SEXP r_object) {
    // TODO: dimnames currently not supported
    PyObject *py_array = r_vec_to_py_list(permute_array_to_numpy(r_object));
    PyObject *py_dim = r_to_py_tuple(GET_DIM(r_object));
    PyObject *py_type = PyInt_FromLong(r_GetR_Type(r_object));
    PyObject *pyo = PY_ARRAY(py_array, py_dim, PY_NONE, py_type);
    return(pyo);
}

/*  ----------------------------------------------------------------------------

    r_to_py_simple_triplet_matrix

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_simple_triplet_matrix(SEXP r_object) {
    // SEXP len = GET_LENGTH(r_object);
    SEXP names = GET_NAMES(r_object);
    int tmp = GLOPT_INT_TO_LONG;
    GLOPT_INT_TO_LONG = 0;
    PyObject *py_object = r_to_py_dict(names, r_object);
    GLOPT_INT_TO_LONG = tmp;
    return PY_STM_FROM_DICT(py_object);
}

PyObject *r_to_py_tlist(SEXP x) {
    int r_type = r_GetR_Type(x);
    if ( r_type < 0 ) {
        error("ValueError: in r_to_py_tlist expected vector got something else!");
    }
    if ( r_type == 11) {
        r_type = 17;
    }
    PyObject *pyo = Py_Tlist(r_vec_to_py_list(x), r_type);
    // TODO: Check Reference Counts! Should I decref py_list and py_names?  
    return(pyo);
}

PyObject *r_to_py_ttuple(SEXP x) {
    int r_type = r_GetR_Type(x);
    if ( r_type < 0 ) {
        error("ValueError: in r_to_py_ttuple expected vector got something else!");
    }
    if ( r_type == 11 ) {
        r_type = 17;
    }
    PyObject *pyo = Py_Ttuple(r_vec_to_py_list(x), r_type);
    // TODO: Check Reference Counts! Should I decref py_list and py_names?  
    return(pyo);
}


/*  ----------------------------------------------------------------------------

    r_to_py_data_frame

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_data_frame(SEXP x) {
    int list_flag = GLOPT_VECTOR_TO_LIST;
    int tlist_flag = GLOPT_VECTOR_TO_TLIST;
    GLOPT_VECTOR_TO_LIST = 0;
    GLOPT_VECTOR_TO_TLIST = 1;
    PyObject *df = r_to_py_dict(GET_NAMES(x), x);
    // Rprintf("r_to_py_data_frame: refcnt(df)=%i\n", REF_CNT(df));
    PyObject *rn = r_to_py(getAttrib(x, mkString("row.names")));
    // Rprintf("r_to_py_data_frame: refcnt(rn)=%i\n", REF_CNT(rn));
    PyObject *cn = r_to_py(GET_NAMES(x));
    // Rprintf("r_to_py_data_frame: refcnt(cn)=%i\n", REF_CNT(cn));
    GLOPT_VECTOR_TO_LIST = list_flag;
    GLOPT_VECTOR_TO_TLIST = tlist_flag;
    PyObject *pyo = PY_DATA_FRAME(df, rn, cn, r_to_py(GET_DIM(x)));
    // Rprintf("r_to_py_data_frame: refcnt(pyo)=%i\n", REF_CNT(pyo));
    // Rprintf("r_to_py_data_frame: refcnt(df)=%i, refcnt(rn)=%i, refcnt(cn)=%i\n", REF_CNT(df), REF_CNT(rn), REF_CNT(cn));
    return pyo;
}

PyObject *r_to_py_pandas_data_frame(SEXP x) {
    PyObject *pyo = r_to_py_data_frame(x);
    // Rprintf("r_to_py_data_frame: refcnt(pyo)=%i\n", REF_CNT(pyo));
    PyObject *z = PyObject_CallMethod(pyo, "to_pandas", "");
    Py_XDECREF(pyo);
    if ( PyNone_Check(z) ) {
        error("counldn't find 'pandas' please make sure 'pandas' is installed!");
    }
    // Rprintf("r_to_py_data_frame: refcnt(pyo)=%i\n", REF_CNT(pyo));
    return z;
}

SEXP Test_r_to_py_data_frame(SEXP x) {
    //return GET_NAMES(x);
    return getAttrib(x, mkString("row.names"));
}

/*  ----------------------------------------------------------------------------

    r_to_py_tree

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_tree(SEXP r_object) {
    PyObject *pyo = PY_TREE(r_to_py_dict(GET_NAMES(r_object), r_object));
    // Rprintf("r_to_py_tree: refcnt(x)=%i\n", REF_CNT(pyo));
    PyObject *x = PyObject_CallMethod(pyo, "to_nltk_tree", "");
    // Rprintf("r_to_py_tree: refcnt(x)=%i\n", REF_CNT(pyo));
    return( x );
}

/*  ----------------------------------------------------------------------------

    r_to_py_tuple

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_tuple(SEXP r_object){
    PyObject *py_object, *item;
    long i, len;

    len = GET_LENGTH(r_object);
    py_object = PyTuple_New(len);

    if (len == 0) return(py_object);
    
    if( IS_LOGICAL(r_object) ){
        for(i = 0; i < len; i++) {
            item = R_TO_PY_BOOLEAN_V(r_object,i);
            PyTuple_SET_ITEM(py_object, i, item);
        }
    }else if ( IS_INTEGER(r_object) ){
        int tmp = GLOPT_INT_TO_LONG;
        if ( has_typehint(r_object, "int") ) {
            GLOPT_INT_TO_LONG = 0;
            for(i = 0; i < len; i++) {
                item = R_TO_PY_LONG_V(r_object,i);
                PyTuple_SET_ITEM(py_object, i, item);
            }
            GLOPT_INT_TO_LONG = tmp;
        } else {
            for(i = 0; i < len; i++) {
                item = R_TO_PY_LONG_V(r_object,i);
                PyTuple_SET_ITEM(py_object, i, item);
            }
        }
    }else if ( IS_NUMERIC(r_object) ){
        for(i = 0; i < len; i++) {
            item = R_TO_PY_DOUBLE_V(r_object,i);
            PyTuple_SET_ITEM(py_object, i, item);
        }
    }else if ( IS_CHARACTER(r_object) ){
        if ( has_typehint(r_object, "string") ) {
            for(i = 0; i < len; i++) {
                item = R_TO_PY_STRING_V(r_object,i);
                PyTuple_SET_ITEM(py_object, i, item);
            }
        } else {
            for(i = 0; i < len; i++) {
                item = R_TO_PY_UNICODE_V(r_object,i);
                PyTuple_SET_ITEM(py_object, i, item);
            }
        }
    }else if ( isComplex(r_object) ){
        Py_XDECREF(py_object);
        error("in r_to_py_tuple\n     conversion of type complex isn't supported jet!");
    }else if ( IS_LIST(r_object) ){
        for(i = 0; i < len; i++) {
            item = r_to_py(VECTOR_ELT(r_object, i));
            PyTuple_SET_ITEM(py_object, i, item);
        }
    }else {
        Py_XDECREF(py_object);
        error("in r_to_py_tuple\n     unkown data type!\n\n");
    }
    return py_object;
}

/*  ----------------------------------------------------------------------------

    r_vec_to_py_list
( IS_LOGICAL(x) || IS_INTEGER(x) || IS_NUMERIC(x) || IS_CHARACTER(x) || isComplex(x) )
  ----------------------------------------------------------------------------*/
PyObject *r_vec_to_py_list(SEXP ro) {
    PyObject *pyo, *item;
    
    int r_type = r_GetR_Type(ro);

    long len = GET_LENGTH(ro);
    pyo = PyList_New(len);
    
    if        ( r_type == 10 ) { R_TO_PY_ITER(ro, R_TO_PY_BOOLEAN_V, pyo, PyList_SET_ITEM);
    } else if ( r_type == 12 ) { R_TO_PY_ITER(ro, R_TO_PY_INT_V,     pyo, PyList_SET_ITEM);
    } else if ( r_type == 13 ) { R_TO_PY_ITER(ro, R_TO_PY_LONG_V,    pyo, PyList_SET_ITEM);
    } else if ( r_type == 14 ) { R_TO_PY_ITER(ro, R_TO_PY_DOUBLE_V,  pyo, PyList_SET_ITEM);
    } else if ( r_type == 16 ) { R_TO_PY_ITER(ro, R_TO_PY_STRING_V,  pyo, PyList_SET_ITEM);
    } else if ( r_type == 17 ) { R_TO_PY_ITER(ro, R_TO_PY_UNICODE_V, pyo, PyList_SET_ITEM);
    } else if ( r_type == 11 ) { R_TO_PY_ITER(ro, R_TO_PY_FACTOR_V,  pyo, PyList_SET_ITEM);    
    }
    return pyo;
}

PyObject *r_list_to_py_list(SEXP ro) {
    PyObject *pyo, *item;
    
    long len = GET_LENGTH(ro);
    pyo = PyList_New(len);
    
    for (long i = 0; i < len; i++) {
        item = r_to_py(VECTOR_ELT(ro, i));
        PyList_SET_ITEM(pyo, i, item);
    }
    return pyo;
}

PyObject *r_to_py_list(SEXP ro) {
    if ( isNull(ro) ) Py_RETURN_NONE;
    
    int container = r_GetR_Container(ro);
    
    if ( (100 <= container) & (container < 200) ) {
        return r_vec_to_py_list(ro);
    } else if ( (400 <= container) & (container < 500) ) {
        return r_list_to_py_list(ro);
    }
    error("TypeError: in r_to_py_list object is no list nor a vector!");
    return NULL;
}

/*  ----------------------------------------------------------------------------

    r_matrix_to_py_list

  ----------------------------------------------------------------------------*/
PyObject *r_matrix_to_py_list(SEXP r_object) {
    PyObject *py_object;
    long k, i, j;
    
    int nrow = INTEGER(GET_DIM(r_object))[0];
    int ncol = INTEGER(GET_DIM(r_object))[1];
       
    py_object = PyList_New(nrow);
    
    int r_type = r_GetR_Type(r_object);
    if ( r_type == 11 ) {
        r_object = AS_CHARACTER(r_object);
        r_type = (GLOPT_CHARACTER_TO_UNICODE) ? 17 : 16;
    }

    SEXP col = PROTECT(allocVector(r_type, ncol));
    for (i = 0; i < nrow; i++) {        
        if( IS_LOGICAL(r_object) ) {
            for(j = 0; j < ncol; j++) {
                k = (j * nrow) + i;
                LOGICAL(col)[j] = LOGICAL(r_object)[k];
            }
        }else if ( IS_INTEGER(r_object) ) {
            int tmp = GLOPT_INT_TO_LONG;
            if ( has_typehint(r_object, "int") ) {
                GLOPT_INT_TO_LONG = 0;
                for(j = 0; j < ncol; j++) {
                    k = (j * nrow) + i;
                    INTEGER(col)[j] = INTEGER(r_object)[k];
                }
                GLOPT_INT_TO_LONG = tmp;
            } else {
                for(j = 0; j < ncol; j++) {
                    k = (j * nrow) + i;
                    INTEGER(col)[j] = INTEGER(r_object)[k];
                }
            }
        }else if ( IS_NUMERIC(r_object) ) {
            for(j = 0; j < ncol; j++) {
                k = (j * nrow) + i;
                REAL(col)[j] = REAL(r_object)[k];
            }
        }else if ( IS_CHARACTER(r_object) ) {
            for(j = 0; j < ncol; j++) {
                k = (j * nrow) + i;
                SET_STRING_ELT(col, j, STRING_ELT(r_object, k));
            }
        }else if ( isComplex(r_object) ) {
            for(j = 0; j < ncol; j++) {
                k = (j * nrow) + i;
                COMPLEX(col)[j] = COMPLEX(r_object)[k];
            }
        }else {
            Py_XDECREF(py_object);
            error("in r_to_py_list\n     unkown data type!\n\n");
        }
        PyList_SET_ITEM(py_object, i, r_to_py_list(col));
    }
    UNPROTECT(1);
    return py_object;
}

/*  ----------------------------------------------------------------------------

    r_to_py_dict

  ----------------------------------------------------------------------------*/
PyObject *r_to_py_dict(SEXP r_keys, SEXP r_values){
    PyObject *py_object, *key, *value;
    long i, len;

    len = GET_LENGTH(r_values);
    py_object = PyDict_New();

    if( IS_LOGICAL(r_values) ){
        for(i = 0; i < len; i++) {
            key = R_TO_PY_UNICODE_V(r_keys,i);
            value = R_TO_PY_BOOLEAN_V(r_values,i);
            PyDict_SetItem(py_object, key, value);
        }
    }else if ( IS_INTEGER(r_values) ){
        int tmp = GLOPT_INT_TO_LONG;
        if ( has_typehint(r_values, "int") ) {
            GLOPT_INT_TO_LONG = 0;
            for(i = 0; i < len; i++) {
                key = R_TO_PY_UNICODE_V(r_keys,i);
                value = R_TO_PY_LONG_V(r_values,i);
                PyDict_SetItem(py_object, key, value);
            }
            GLOPT_INT_TO_LONG = tmp;
        } else {
            for(i = 0; i < len; i++) {
                key = R_TO_PY_UNICODE_V(r_keys,i);
                value = R_TO_PY_LONG_V(r_values,i);
                PyDict_SetItem(py_object, key, value);
            }
        }
    }else if ( IS_NUMERIC(r_values) ){
        for(i = 0; i < len; i++) {
            key = R_TO_PY_UNICODE_V(r_keys,i);
            value = R_TO_PY_DOUBLE_V(r_values,i);
            PyDict_SetItem(py_object, key, value);
        }
    }else if ( IS_CHARACTER(r_values) ){
        for(i = 0; i < len; i++) {
            key = R_TO_PY_UNICODE_V(r_keys,i);
            value = R_TO_PY_UNICODE_V(r_values,i);
            PyDict_SetItem(py_object, key, value);
        }
    }else if ( isComplex(r_values) ){
        Py_XDECREF(py_object);
        error("in r_to_py_dict\n     conversion of type complex isn't supported jet!");
    }else if ( IS_LIST(r_values) ){
        for(i = 0; i < len; i++) {
            key = R_TO_PY_UNICODE_V(r_keys,i);
            value = r_to_py(VECTOR_ELT(r_values, i));
            PyDict_SetItem(py_object, key, value);
        }
    }else {
        Py_XDECREF(py_object);
        error("in r_to_py_dict\n     unkown data type!\n\n");
    }    
    return py_object;
}

SEXP test_r_flags(SEXP x){
    Rprintf("IS_NULL: %i\n", x==NULL);
    Rprintf("IS_LOGICAL: %i\n", IS_LOGICAL(x));
    Rprintf("IS_INTEGER: %i\n", IS_INTEGER(x));
    Rprintf("IS_NUMERIC: %i\n", IS_NUMERIC(x));
    Rprintf("IS_CHARACTER: %i\n", IS_CHARACTER(x));
    Rprintf("isComplex: %i\n", isComplex(x));
    Rprintf("IS_LIST: %i\n", IS_LIST(x));

    Rprintf("isArray       : %i\n", isArray(x));
    Rprintf("isComplex     : %i\n", isComplex(x));
    Rprintf("isEnvironment : %i\n", isEnvironment(x));
    Rprintf("isExpression  : %i\n", isExpression(x));
    Rprintf("isFactor      : %i\n", isFactor(x));
    Rprintf("isFrame       : %i\n", isFrame(x));
    Rprintf("isFunction    : %i\n", isFunction(x));
    Rprintf("isInteger     : %i\n", isInteger(x));
    Rprintf("isLanguage    : %i\n", isLanguage(x));
    Rprintf("isList        : %i\n", isList(x));
    Rprintf("isLogical     : %i\n", isLogical(x));
    Rprintf("isSymbol      : %i\n", isSymbol(x));
    Rprintf("isMatrix      : %i\n", isMatrix(x));
    Rprintf("isNewList     : %i\n", isNewList(x));
    Rprintf("isNull        : %i\n", isNull(x));
    Rprintf("isNumeric     : %i\n", isNumeric(x));
    Rprintf("isNumber      : %i\n", isNumber(x));
    Rprintf("isObject      : %i\n", isObject(x));
    Rprintf("isOrdered     : %i\n", isOrdered(x));
    Rprintf("isPairList    : %i\n", isPairList(x));
    Rprintf("isPrimitive   : %i\n", isPrimitive(x));
    Rprintf("isReal        : %i\n", isReal(x));
    Rprintf("isS4          : %i\n", isS4(x));
    Rprintf("isString      : %i\n", isString(x));
    Rprintf("isTs          : %i\n", isTs(x));
    Rprintf("isUnordered   : %i\n", isUnordered(x));
    Rprintf("isUserBinop   : %i\n", isUserBinop(x));
    Rprintf("isValidString : %i\n", isValidString(x));
    Rprintf("isValidStringF: %i\n", isValidStringF(x));
    Rprintf("isVector      : %i\n", isVector(x));
    Rprintf("isVectorAtomic: %i\n", isVectorAtomic(x));
    Rprintf("isVectorizable: %i\n", isVectorizable(x));
    Rprintf("isVectorList  : %i\n", isVectorList(x));

    return R_NilValue;
}

const char *get_class_name_vec(SEXP x, int len) {
    int o = (len == 1);
    if( IS_LOGICAL( x ) )
        return (o) ? "logical" : "vector.logical";
    else if( IS_INTEGER( x ) ) {
        if ( has_typehint(x, "int") )
            return (o) ? "integer" : "vector.integer";
        else
            return (o) ? "long" : "vector.long";
    } else if( IS_NUMERIC( x ) )
        return (o) ? "numeric" : "vector.numeric";
    else if ( IS_CHARACTER( x ) ) {
        if ( has_typehint(x, "string") )
            return (o) ? "string" : "vector.string";
        else if ( has_typehint(x, "bytes") )
            return (o) ? "bytes" : "vector.bytes";
        else
            return (o) ? "unicode" : "vector.unicode";
    } else if ( isComplex( x ) ) 
        return (o) ? "complex" : "vector.complex";
    return NULL;
}

const char *get_class_name(SEXP x) {
    
    if ( x == NULL ) 
        return "NULL";
    else if ( isPyInR_PyObject( x ) ) {
        return "PythonInR_Object";
    } if ( IS_RVECTOR( x ) & !isArray( x ) ) {
        return get_class_name_vec(x, GET_LENGTH(x));
    } else if ( isArray( x ) & !isMatrix( x ) ) {
        return "array";
    } else if ( isMatrix( x ) ) {
        return "matrix";
    } else if ( IS_LIST( x ) ) {
        if ( isFrame( x ) ) {
            return "data.frame";
        } else if ( GET_LENGTH(GET_NAMES(x)) > 0 ) {
            return "named.list";
        } else {
            return "list";
        } 
    } else if ( GET_LENGTH(x) == 0 ) {
        return "unknown.len0";
    }
    return "unknown";
}

/*  ----------------------------------------------------------------------------

    isPythonInRObject
    
    Returns True if x is a PythonInR PyObject.
    
  ----------------------------------------------------------------------------*/
int isPyInR_PyObject(SEXP x) {
    int is_py_in_r_obj = 0;
    if ( isS4(x) ) return(is_py_in_r_obj);
    SEXP cls = getAttrib(x, R_ClassSymbol);
    if (IS_CHARACTER(cls)){
    	for (int i = 0; i < GET_LENGTH(cls); i++) {
        	if ( strncmp(R_TO_C_STRING_V(cls, i), "PythonInR_Object", 16) == 0 )
        		return 1;
        }
    }
    return is_py_in_r_obj;
}

const char *r_get_py_object_location(SEXP y) {
    SEXP x, cx, names;
    int i, len;
    
    x = CAR(y);
    names = GET_NAMES(x);
    len = GET_LENGTH(x);
    
    for(i = 0; i < len; i++) {
        if ( strcmp(R_TO_C_STRING_V(names, i), ".name") == 0 ) {
            cx = nthcdr(x, (int) i);
            x = CAR(cx);
            return R_TO_C_STRING(x);
        }
    }
    // in case it is a funciton
    SEXP nam = getAttrib(y, c_to_r_string("name"));
    if ( !isNull(y) ) return R_TO_C_STRING(nam);
    return NULL;
}

SEXP test_r_get_py_object_location(SEXP x) {
	const char *y = r_get_py_object_location(x);
	return c_to_r_string(y);
}

SEXP r_to_py_preprocessing(SEXP x) {
    SEXP cls = getAttrib(x, R_ClassSymbol);
    if ( cls == NULL ) 
        return x;
    
    SEXP e;
    int hadError;
    char c_string[MAXELTSIZE+1];
    
    snprintf(c_string, MAXELTSIZE + 1, 
             "PythonInR:::r_to_py_preprocessing[['%s']]", 
             CHAR(STRING_ELT(cls, 0)));
    
    SEXP fun = r_eval_string(c_string);
    if ( fun == NULL ) 
        return x;
    
    PROTECT(e = allocVector(LANGSXP, 2));   
    SETCAR(e, fun);

    SETCADR(e, x);
    SET_TAG(CDR(e), install( "x" ));
    SEXP r_obj = R_tryEval(e, NULL, &hadError);
    
    if (hadError){
        Rprintf("an error occurred in r_to_py_preprocessing\n");
    }
    UNPROTECT(1);
    return(r_obj);
}

SEXP r_to_py_preprocessing_class(SEXP x, const char *cls) {
    SEXP e;
    int hadError;
    char c_string[MAXELTSIZE+1];
    
    snprintf(c_string, MAXELTSIZE + 1, 
             "PythonInR:::r_to_py_preprocessing[['%s']]", 
             cls);
    
    SEXP fun = r_eval_string(c_string);
    if ( fun == NULL ) 
        return x;
    
    PROTECT(e = allocVector(LANGSXP, 2));   
    SETCAR(e, fun);

    SETCADR(e, x);
    SET_TAG(CDR(e), install( "x" ));
    SEXP r_obj = R_tryEval(e, NULL, &hadError);
    
    if (hadError){
        Rprintf("an error occurred in r_to_py_preprocessing\n");
    }
    UNPROTECT(1);
    return(r_obj);
}

SEXP r_container_type(SEXP x) {
    if ( isNull(x) ) return R_NilValue;
    
    int container = r_GetR_Container(x);
    return c_to_r_integer(container);
}

/*  ----------------------------------------------------------------------------

    r_to_py
    
    Returns New reference! 
    
  ----------------------------------------------------------------------------*/
PyObject *r_to_py(SEXP x) {
    
    if ( isNull(x) ) Py_RETURN_NONE;
    
    int container = r_GetR_Container(x);
    
    if ( (100 <= container) & (container < 400) ) { /** Vector - Matrix Array**/
        /** Vector **/
        if ( container == 100 ) return r_to_py_vector(x);
        if ( container == 110 ) return r_to_py_scalar(x);
        if ( container == 120 ) return r_to_py_tlist(x);
        if ( container == 130 ) return r_to_py_ttuple(x);
        if ( container == 140 ) return PY_VEC_TO_NUMPY_ARRAY(r_to_py_tlist(x));
        if ( container == 150 ) return r_vec_to_py_list(x);
        if ( container == 160 ) return r_to_py_tuple(x);
        
        /** Matrix **/
        if ( container == 200 ) return r_to_py_matrix(x);
        if ( container == 210 ) return PY_MATRIX_TO_LIL(x);
        if ( container == 220 ) return PY_MATRIX_TO_NUMPY(r_to_py_matrix(x));
        if ( container == 230 ) return PY_MATRIX_TO_CVXOPT(r_to_py_matrix(x));
        
        /** Array **/
        if ( container == 300 ) return r_to_py_array(x);
        if ( container == 310 ) return PY_ARRAY_TO_NUMPY(r_to_py_array(x));

    } else if ( (400 <= container) & (container < 600) ) {
        /** list **/
        if ( container == 400 ) return r_list_to_py_list(x);
        if ( container == 401 ) return r_to_py_tuple(x);

        /** named list **/
        if ( container == 430 ) return r_to_py_dict(GET_NAMES(x), x);

        /** data.frame **/
        if ( container == 500 ) return r_to_py_data_frame(x);
        if ( container == 510 ) return r_to_py_pandas_data_frame(x);

        /** simple_triplet_matrix (sparse matrix formats) **/
        if ( container == 420 ) return r_to_py_simple_triplet_matrix(x);
        if ( container == 421 ) return PY_STM_TO_CVXOPT(x);
        if ( container == 422 ) return PY_STM_TO_BSR(x);
        if ( container == 423 ) return PY_STM_TO_COO(x);
        if ( container == 424 ) return PY_STM_TO_CSC(x);
        if ( container == 425 ) return PY_STM_TO_CSR(x);
        if ( container == 426 ) return PY_STM_TO_DIA(x);
        if ( container == 427 ) return PY_STM_TO_DOK(x);
        if ( container == 428 ) return PY_STM_TO_LIL(x);

        /** nlp.Tree **/
        if ( container == 410 ) {
            // Rprintf("r_to_py: container=410\n");
            return r_to_py_tree(x);
        }

    } else if ( container == 700 ) {
        const char *py_obj_name = r_get_py_object_location(x);
        if ( py_obj_name == NULL) error("PythonInR object is not valid!");
        return py_get_py_obj( py_obj_name );
    }
    
    Py_RETURN_NONE; 

/** 
    PyObject *py_object = PY_NONE;
    long len=-1; 
    SEXP names;
      
    if ( isPyInR_PyObject(r_object) ){
        const char *py_obj_name = r_get_py_object_location(r_object);
        if ( py_obj_name == NULL) error("PythonInR object is not valid!");
        py_object = py_get_py_obj( py_obj_name );
        return py_object;
    } else if ( compare_r_class(r_object, "tuple") ) {
        py_object = r_to_py_tuple(r_object);
        return py_object;
    }
    
    len = GET_LENGTH(r_object);
    names = GET_NAMES(r_object);
           
    if ( IS_RVECTOR(r_object) & !isArray(r_object) ) {                  // Case 2: Convert to int, unicode, ...!
        if ( (len == 1) & !(HAS_TH_VECTOR(r_object) | HAS_TH_LIST(r_object) | HAS_TH_TUPLE(r_object)) ) {
            py_object = r_to_py_scalar(r_object);
        } else {                                                        // Case 3: Convert to Vector
            if ( r_vec_to_list_flag | has_typehint(r_object, "list") ) {
                py_object = r_to_py_list(r_object);
            } else if ( has_typehint(r_object, "tuple") ) {
                py_object = r_to_py_tuple(r_object);
            } else {
                py_object = r_to_py_vector(names, r_object);
            }
        }
    } else if ( isArray(r_object) & !isMatrix(r_object) ) {
        py_object = r_to_py_array(r_object);
    } else if ( isMatrix(r_object) ) {
        py_object = r_to_py_matrix(r_object);
    } else if ( IS_LIST(r_object) ) {
        if ( compare_r_class(r_object, "Tree") ) {
            py_object = r_to_py_tree(r_object);
        } else if ( compare_r_class(r_object, "simple_triplet_matrix") ) {
            py_object = r_slam_to_py_sparse(r_object, 1);
        } else if ( isFrame(r_object) ) {
            py_object = r_to_py_dataFrame(r_object);
        } else if( GET_LENGTH(names) > 0 ) {                            // Case 1: R object has names!        
            py_object = r_to_py_dict(names, r_object);
        } else {                                                        // Case 3: R object is a list!
            py_object = r_to_py_list(r_object);
        }
    } else if ( len == 0 ) {                                            // Case 4: Convert R NULL or character(0), ... to Py_None
        Py_RETURN_NONE; // Return value: New reference.
    } else {
        error("the provided R object can not be type cast into an Python object\n"); 
    }
    return py_object;
**/
}
