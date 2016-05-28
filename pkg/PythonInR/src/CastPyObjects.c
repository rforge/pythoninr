/*  ----------------------------------------------------------------------------

    PyToRbasic

    Provides functions to convert non nested Python data types to R data types.

  ----------------------------------------------------------------------------*/
#include "CastPyObjects.h"

//#define     NILSXP       0 /* nil = NULL */
//#define     SYMSXP       1 /* symbols */
//#define     LISTSXP      2 /* lists of dotted pairs */
//#define     CLOSXP       3 /* closures */
//#define     ENVSXP       4 /* environments */
//#define     PROMSXP      5 /* promises: [un]evaluated closure arguments */
//#define     LANGSXP      6 /* language constructs (special lists) */
//#define     SPECIALSXP   7 /* special forms */
//#define     BUILTINSXP   8 /* builtin non-special forms */
//#define     CHARSXP      9 /* "scalar" string type (internal only)*/
//#define     LGLSXP      10 /* logical vectors */
/* 11 and 12 were factors and ordered factors in the 1990s */
//#define     INTSXP      13 /* integer vectors */
//#define     REALSXP     14 /* real variables */
//#define     CPLXSXP     15 /* complex variables */
//#define     STRSXP      16 /* string vectors */
//#define     DOTSXP      17 /* dot-dot-dot object */

/*
const char *py_get_type_name(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return( c_type_name );
}
*/

int Py_Vector_Check(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, "PythonInR.vector") == 0);
}

int Py_Matrix_Check(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, "PythonInR.matrix") == 0);
}

int Py_Array_Check(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, "PythonInR.array") == 0);
}

int Py_Slam_Check(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, "PythonInR.simple_triplet_matrix") == 0);
}

int Py_DataFrame_Check(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, "PythonInR.data_frame") == 0);
}

int Py_NlpTree_Check(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, "PythonInR.Tree") == 0);
}

int Py_Tree_Check(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, "Tree") == 0);
}

int Py_Error_Check(PyObject *py_object) {
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    return(strcmp(c_type_name, "PythonInR.error") == 0);
}

int has_names(PyObject *pyo) {
    PyObject *x = PyObject_CallMethod(pyo, "_has_names", "");
    int y = PY_TO_C_BOOLEAN(x);
    Py_XDECREF(x);
    return(y);
}

/*  ----------------------------------------------------------------------------

    py_class 
      transforms python into class objects
      
      Increases the reference count from py_object + 1
      
      TODO: The reference counts are consistent with PythonInR_Run_String, 
            double check if it is also consistient with the other use cases!
      
      TODO: Allow the user to overload this meachnism, so I can control
            from R if a PythonObject should be returned or another thing.

  ----------------------------------------------------------------------------*/
SEXP py_class(PyObject *py_object){
    SEXP r_list, r_list_names;
    PyObject *py_main, *py_pyinr, *py_r_namesp;
    
    //Rprintf("pyrNamespaceCounter: %i\n", pyrNamespaceCounter);
    
    // Since the value can't be returned to R I save it in Python
    // PyModule_GetDict -> Borrowed reference, PyImport_AddModule -> Borrowed reference
    py_main = PyModule_GetDict(PyImport_AddModule("__main__"));
    // PyDict_GetItemString -> Borrowed reference
    py_pyinr = PyDict_GetItemString(py_main, "__R__"); // PyModule_GetDict(PyImport_AddModule("__R__")); //   
    if (py_pyinr == NULL) error("Couldn't find the object '__R__'\n");
    
    py_r_namesp = PyObject_GetAttrString(py_pyinr, "namespace"); //     PyObject_GetItem(py_pyinr, py_key)
    if (py_r_namesp == NULL) error("Couldn't find the object 'namespace'\n");
    int success = PyDict_SetItem(py_r_namesp, PyLong_FromLong(pyrNamespaceCounter), py_object);
    if (success < 0) Rprintf("Error int py_class PyDict_SetItem returned -1\n"); // TODO: make real error handling!
    PROTECT(r_list = allocVector(VECSXP, 3));
    PROTECT(r_list_names = allocVector(VECSXP, 3));
    
    // set isCallable
    int c_is_callable = PyCallable_Check(py_object);
    SET_VECTOR_ELT(r_list_names, 0, c_to_r_string("isCallable"));
    SET_VECTOR_ELT(r_list, 0, c_to_r_integer(c_is_callable));
    
    // set id
    SET_VECTOR_ELT(r_list_names, 1, c_to_r_string("id"));
    SET_VECTOR_ELT(r_list, 1, c_to_r_integer(pyrNamespaceCounter));
    
    // class name   
    // This is taken from the python soure, they normaly use the Makro
    // Py_TYPE e.g.
    // #define Py_TYPE(ob) (((PyObject*)(ob))->ob_type)
    // Py_TYPE(arg)->tp_name
    // since I only use it once I just use it directly since they also
    // use it in error messages it should never fail!
    // const char *c_type_name = (((PyObject*)(py_object))->ob_type)->tp_name;
    const char *c_type_name = Py_TYPE(py_object)->tp_name;
    SET_VECTOR_ELT(r_list_names, 2, c_to_r_string("type"));
    SET_VECTOR_ELT(r_list, 2, c_to_r_string(c_type_name));
    
    setAttrib(r_list, R_NamesSymbol, r_list_names);
        
    // Every Value which can't be transformed is returned to R as PythonObject
    classgets(r_list, c_to_r_string("PythonObject"));
    
    UNPROTECT(2);
    
    pyrNamespaceCounter = pyrNamespaceCounter + 1;
    
    return r_list;
}

/*  ----------------------------------------------------------------------------
    PyList_AllSameType
    --------------------------------------------------------------------------*/
int PyList_AllSameType(PyObject *py_object){
    PyObject *item, *py_len, *py_i;
    long list_len, count;
    int r_type = -1, item_type;

    py_len = PyLong_FromSsize_t(PyList_GET_SIZE(py_object));
    list_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);
    
    if ( list_len == 0 ) return -2;
    
    py_i = PyLong_FromLong(0);
    item = PyList_GetItem(py_object, PyLong_AsSsize_t(py_i));
    Py_XINCREF(item); // If item is NULL Py_XINCREF has no effect.
    Py_XDECREF(py_i);
    if ( item == NULL ) return 0;
    r_type = Py_GetR_Type(item); // just makes sence for the types which exists in R
    Py_XDECREF(item);
    if ( r_type == -1 ) return r_type; // -1 is returned if it is not (None, boolean, int, long, float, string or unicode)

    count = 0;
    for (long i=1; i < list_len; i++){
        py_i = PyLong_FromLong(i);
        item = PyList_GetItem(py_object, PyLong_AsSsize_t(py_i));
        Py_XINCREF(item);
        Py_XDECREF(py_i);
        item_type = Py_GetR_Type(item);
        count += ( (r_type != item_type) && (0 != item_type) );
        Py_XDECREF(item);
        if (count > 0) break;
    }

    r_type = (count == 0) ? r_type : -1;

    return r_type;
}

/*  ----------------------------------------------------------------------------
    PyTuple_AllSameType
    --------------------------------------------------------------------------*/
int PyTuple_AllSameType(PyObject *py_object){
    PyObject *item, *py_len, *py_i;
    long list_len, count;
    int r_type = -1, item_type;

    py_len = PyLong_FromSsize_t(PyTuple_GET_SIZE(py_object));
    list_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);

    py_i = PyLong_FromLong(0);
    item = PyTuple_GetItem(py_object, PyLong_AsSsize_t(py_i));
    Py_XINCREF(item);
    Py_XDECREF(py_i);
    if ( item == NULL ) return 0;
    r_type = Py_GetR_Type(item); // just makes sence for the types which exists in R
    Py_DECREF(item);
    if ( r_type == -1 ) return r_type;

    count = 0;
    for (long i=1; i < list_len; i++){
        py_i = PyLong_FromLong(i);
        item = PyTuple_GetItem(py_object, PyLong_AsSsize_t(py_i));
        Py_XINCREF(item);
        Py_XDECREF(py_i);
        item_type = Py_GetR_Type(item);
        count += ( (r_type != item_type) && (0 != item_type) );
        Py_XDECREF(item);
        if (count > 0) break;
    }

    r_type = (count == 0) ? r_type : -1;

    return r_type;
}

/*  ----------------------------------------------------------------------------
    PyDict_AllSameType
    --------------------------------------------------------------------------*/
int PyDict_AllSameType(PyObject *py_object){
    PyObject *py_values;
    int r_type;
    // PyDict_Values -> New reference
    py_values = PyDict_Values(py_object);
    r_type = PyList_AllSameType(py_values);
    Py_XDECREF(py_values);
    return  r_type;
}

/*  ----------------------------------------------------------------------------

    py_vec_to_r_vec

  ----------------------------------------------------------------------------*/
SEXP py_vec_to_r_vec(PyObject *py_keys, PyObject *py_values, int r_vector_type){
    SEXP r_vec;

    // TODO: here would the data type come in!
    if (r_vector_type == 0) return R_NilValue;

    r_vec = py_list_to_r_vec(py_values, r_vector_type);
    setAttrib(r_vec, R_NamesSymbol, py_list_to_r_vec(py_keys, r_vector_type));
    
    return r_vec;
}

/*  ----------------------------------------------------------------------------

    py_dict_to_r_vec

  ----------------------------------------------------------------------------*/
SEXP py_dict_to_r_vec(PyObject *py_object, int r_vector_type){
    PyObject *item, *py_keys, *py_values, *py_len, *py_i;
    SEXP r_vec, r_vec_names;
    long vec_len;

    if (r_vector_type == 0) return R_NilValue;

    py_len = PyLong_FromSsize_t(PyDict_Size(py_object));
    vec_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);
    item = NULL;
    py_keys = PyDict_Keys(py_object);
    py_values = PyDict_Values(py_object);

    PROTECT(r_vec = allocVector(r_vector_type, vec_len));
    PROTECT(r_vec_names = allocVector(VECSXP, vec_len)); // allocate it as list since in Python it just has to be an unmuateable
    
    // TODO: check vec_len = 0

    // TODO: I return now NULL instead of list(NULL) which should also
        //       be possible I would some how set a NULL with class list
    if (r_vector_type == 10){                                           // boolean
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyList_GetItem(py_keys, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            SET_VECTOR_ELT(r_vec_names, i, py_to_r(item, 0, 1));
            Py_XDECREF(item);
            item = PyList_GetItem(py_values, PyLong_AsSsize_t(py_i));
            Py_XDECREF(item);
            Py_XINCREF(item);
            // to handle NA variables of type None are transformed to NA
            if ( Py_GetR_Type(item) == 0 ){
                LOGICAL(r_vec)[i] = INT_MIN;
            }else{
                LOGICAL(r_vec)[i] = PY_TO_C_BOOLEAN(item);
            }
            // Py_XDECREF(item); Booleans never follow the api in Python!
            Py_DECREF(py_i);
        }
    }else if ( (r_vector_type == 12) | (r_vector_type == 13) ) {        // integer
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyList_GetItem(py_keys, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);         
            SET_VECTOR_ELT(r_vec_names, i, py_to_r(item, 0, 1));
            Py_XDECREF(item);
            item = PyList_GetItem(py_values, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            // to handle NA variables of type None are transformed to NA
            if ( Py_GetR_Type(item) == 0 ){
                INTEGER(r_vec)[i] = INT_MIN;
            }else{
                INTEGER(r_vec)[i] = py_to_c_integer(item);
            }
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else if (r_vector_type == 14){                                   // numeric
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyList_GetItem(py_keys, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            SET_VECTOR_ELT(r_vec_names, i, py_to_r(item, 0, 1));
            Py_XDECREF(item);
            item = PyList_GetItem(py_values, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            REAL(r_vec)[i] = PY_TO_C_DOUBLE(item);
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else if (r_vector_type == 16){                                 // character
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyList_GetItem(py_keys, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            SET_VECTOR_ELT(r_vec_names, i, py_to_r(item, 0, 1));
            Py_XDECREF(item);
            item = PyList_GetItem(py_values, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            SET_STRING_ELT(r_vec, i, mkCharCE(py_to_c_string(item), CE_UTF8));
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else{
        UNPROTECT(2);
        error("in py_dict_to_r_vec (ERROR CODE 0001)!\n");          // shouldn't happen!!
    }

    setAttrib(r_vec, R_NamesSymbol, r_vec_names);
    
    Py_XDECREF(py_keys);
    Py_XDECREF(py_values);

    UNPROTECT(2);
    return r_vec;
}

/*  ----------------------------------------------------------------------------

    py_dict_to_r_list

  ----------------------------------------------------------------------------*/
SEXP py_dict_to_r_list(PyObject *py_object, int simplify) {
    Rprintf("py_dict_to_r_list\n");
    PyObject *item, *py_keys, *py_values, *py_len, *py_i;
    SEXP r_list, r_list_names;
    long list_len;
    py_len = PyLong_FromSsize_t(PyDict_Size(py_object));
    list_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);

    item = NULL;

    py_keys = PyDict_Keys(py_object);
    py_values = PyDict_Values(py_object);

    PROTECT(r_list = allocVector(VECSXP, list_len));
    PROTECT(r_list_names = allocVector(VECSXP, list_len));

    for (long i=0; i < list_len; i++){
        // PyList_GetItem is a borrowed reference!
        py_i = PyLong_FromLong(i);

        item = PyList_GetItem(py_keys, PyLong_AsSsize_t(py_i));
        Py_XINCREF(item);
        SET_VECTOR_ELT(r_list_names, i, py_to_r(item, 0, 1));
        Py_XDECREF(item);

        item = PyList_GetItem(py_values, PyLong_AsSsize_t(py_i));
        Py_XINCREF(item);
        SET_VECTOR_ELT(r_list, i, py_to_r(item, simplify, 1));
        Py_XDECREF(item);

        Py_XDECREF(py_i);
    }

    Py_XDECREF(py_keys);
    Py_XDECREF(py_values);

    setAttrib(r_list, R_NamesSymbol, r_list_names);

    UNPROTECT(2);
    Rprintf("py_dict_to_r_list=end\n");
    return r_list;
}

/*  ----------------------------------------------------------------------------

    py_list_to_r_vec

  ----------------------------------------------------------------------------*/
SEXP py_list_to_r_vec(PyObject *py_object, int r_vector_type){
    PyObject *item, *py_len, *py_i;
    SEXP r_vec;
    long vec_len;
    if (r_vector_type == 0) return R_NilValue; // since you also can't create NULL vectors in R
    
    py_len = PyLong_FromSsize_t(PyList_GET_SIZE(py_object));
    vec_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);
    item = NULL;

    PROTECT(r_vec = allocVector(r_vector_type, vec_len));
    if (r_vector_type == 10){                                         // boolean
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyList_GetItem(py_object, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            // to handle NA variables of type None are transformed to NA
            if ( Py_GetR_Type(item) == 0 ){
                LOGICAL(r_vec)[i] = INT_MIN;
            }else{
                LOGICAL(r_vec)[i] = PY_TO_C_BOOLEAN(item);
            }
            // Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else if ( (r_vector_type == 12) | (r_vector_type == 13) ) {        // integer
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyList_GetItem(py_object, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            // to handle NA variables of type None are transformed to NA
            if ( Py_GetR_Type(item) == 0 ){
                INTEGER(r_vec)[i] = INT_MIN;
            }else{
                INTEGER(r_vec)[i] = py_to_c_integer(item);
            }
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else if (r_vector_type == 14){                                   // numeric
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyList_GetItem(py_object, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            REAL(r_vec)[i] = PY_TO_C_DOUBLE(item);
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else if (r_vector_type == 16){                                 // character
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyList_GetItem(py_object, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            SET_STRING_ELT(r_vec, i, mkCharCE(py_to_c_string(item), CE_UTF8));
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else{
        error("in py_list_to_r_vec\n");
    }

    UNPROTECT(1);

    return r_vec;
}


/*  ----------------------------------------------------------------------------
    
    py_tuple_to_r_vec

  ----------------------------------------------------------------------------*/
SEXP py_tuple_to_r_vec(PyObject *py_object, int r_vector_type){
    PyObject *item, *py_len, *py_i;
    SEXP r_vec;
    long vec_len;
    
    if (r_vector_type == 0) return R_NilValue; // since you also can't create NULL vectors in R
    
    py_len = PyLong_FromSsize_t(PyTuple_GET_SIZE(py_object));
    vec_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);
    item = NULL;

    PROTECT(r_vec = allocVector(r_vector_type, vec_len));

    if (r_vector_type == 10){                                         // boolean
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyTuple_GetItem(py_object, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            if ( Py_GetR_Type(item) == 0 ){
                LOGICAL(r_vec)[i] = INT_MIN;
            }else{
                LOGICAL(r_vec)[i] = PY_TO_C_BOOLEAN(item);
            }
            //Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else if ( (r_vector_type == 12) | (r_vector_type == 13) ) {        // integer
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyTuple_GetItem(py_object, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            if ( Py_GetR_Type(item) == 0 ){
                INTEGER(r_vec)[i] = INT_MIN;
            }else{
                INTEGER(r_vec)[i] = py_to_c_integer(item);
            }
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else if (r_vector_type == 14){                                     // numeric
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyTuple_GetItem(py_object, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            REAL(r_vec)[i] = PY_TO_C_DOUBLE(item);
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else if (r_vector_type == 16){                                     // character
        for (long i=0; i < vec_len; i++){
            py_i = PyLong_FromLong(i);
            item = PyTuple_GetItem(py_object, PyLong_AsSsize_t(py_i));
            Py_XINCREF(item);
            SET_STRING_ELT(r_vec, i, mkCharCE(py_to_c_string(item), CE_UTF8));
            Py_XDECREF(item);
            Py_DECREF(py_i);
        }
    }else{
        error("in py_list_to_r_vec\n");
    }

    UNPROTECT(1);

    return r_vec;
}

SEXP py_ttuple_to_r_vector(PyObject *pyo) {
    if ( pyo == NULL ) {
        Rprintf("py_ttuple_to_r_vector is NULL!\n");
        return( R_NilValue );
    }
    PyObject *py_r_type = PyObject_CallMethod(pyo, "_r_type", "");
    int r_type = PY_TO_C_INTEGER(py_r_type);
    Py_XDECREF(py_r_type);
    return( py_tuple_to_r_vec(pyo, r_type) );
}

/*  ----------------------------------------------------------------------------

    py_list_to_r_list

  ----------------------------------------------------------------------------*/
SEXP py_list_to_r_list(PyObject *py_object, int simplify){
    PyObject *item, *py_len, *py_i;
    SEXP r_list;
    long list_len;
    py_len = PyLong_FromSsize_t(PyList_GET_SIZE(py_object));
    list_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);

    item = NULL;
    
    PROTECT(r_list = allocVector(VECSXP, list_len));

    for (long i=0; i < list_len; i++){
        // PyList_GetItem is a borrowed reference!
        py_i = PyLong_FromLong(i);

        item = PyList_GetItem(py_object, PyLong_AsSsize_t(py_i));
        Py_XINCREF(item);
        SET_VECTOR_ELT(r_list, i, py_to_r(item, simplify, 1));
        Py_XDECREF(item);

        Py_XDECREF(py_i);
    }

    UNPROTECT(1);
    return r_list;
}


/*  ----------------------------------------------------------------------------
    
    py_tuple_r_list

  ----------------------------------------------------------------------------*/
SEXP py_tuple_to_r_list(PyObject *py_object, int simplify){
    PyObject *item, *py_len, *py_i;
    SEXP r_list;
    long list_len;
    py_len = PyLong_FromSsize_t(PyTuple_GET_SIZE(py_object));
    list_len = PY_TO_C_LONG(py_len);
    Py_XDECREF(py_len);

    item = NULL;
    
    PROTECT(r_list = allocVector(VECSXP, list_len));
    for (long i=0; i < list_len; i++){
        // PyTuple_GetItem is a borrowed reference!
        py_i = PyLong_FromLong(i);

        item = PyTuple_GetItem(py_object, PyLong_AsSsize_t(py_i));
        Py_XINCREF(item);
        SET_VECTOR_ELT(r_list, i, py_to_r(item, simplify, 1));
        Py_XDECREF(item);

        Py_DECREF(py_i);
    }
    
    UNPROTECT(1);
       
    return r_list;
}

/*  ----------------------------------------------------------------------------
    
    py_vector_to_r_vec

## TODO: add the special function based on the dtype
  ----------------------------------------------------------------------------*/
SEXP py_vector_to_r_vec(PyObject *obj) {
    if ( obj == NULL ) {
        Rprintf("py_vector_to_r_vec is NULL!\n");
        return( R_NilValue );
    }
    PyObject *py_r_type = PyObject_CallMethod(obj, "_r_type", "");
    int r_type = PY_TO_C_INTEGER(py_r_type);
    Py_XDECREF(py_r_type);
    if ( has_names(obj) ) {
        PyObject *py_names = PyObject_GetAttrString(obj, "names");
        return(py_vec_to_r_vec(py_names, obj, r_type));
    } else {
        return(py_list_to_r_vec(obj, r_type));
    }
    return(R_NilValue);
}

SEXP py_tlist_to_r_vector(PyObject *pyo) {
    if ( pyo == NULL ) {
        Rprintf("py_list_to_r_vec is NULL!\n");
        return( R_NilValue );
    }
    PyObject *py_r_type = PyObject_CallMethod(pyo, "_r_type", "");
    int r_type = PY_TO_C_INTEGER(py_r_type);
    Py_XDECREF(py_r_type);
    return( py_list_to_r_vec(pyo, r_type) );
}

SEXP py_numpy_vector_to_r_vector(PyObject *pyo) {
    Py_XINCREF(pyo);
    PyObject *py_tlist = PY_NUMPY_VEC_TO_TLIST(pyo);
    SEXP robj = py_tlist_to_r_vector(py_tlist);
    Py_XDECREF(py_tlist);
    return robj;
}

SEXP py_matrix_to_r_matrix(PyObject *pyo) {
    if ( pyo == NULL ) {
        Rprintf("py_matrix_to_r_matrix is NULL!\n");
        return( R_NilValue );
    }  
    PyObject *x = PyObject_CallMethod(pyo, "to_r", "");
    SEXP robj = matrix_from_list(PY_TO_R__DICT(x));
    Py_XDECREF(x);
    return robj;
}

SEXP py_array_to_r_array(PyObject *obj) {
    PyObject *x = PyObject_CallMethod(obj, "to_r", "");
    if ( x == NULL ) {
        Rprintf("py_array_to_r_array is NULL!\n");
        return( R_NilValue );
    }
    SEXP rval = py_to_r_postprocessing(py_to_r(x, 1, 1), "array");
    Py_XDECREF(x);
    return(rval);
}

SEXP py_slam_to_r_slam(PyObject *obj) {
    PyObject *x = PyObject_CallMethod(obj, "to_r", "");
    if ( x == NULL ) {
        Rprintf("py_slam_to_r_slam is NULL!\n");
        return( R_NilValue );
    }
    SEXP rval = py_to_r_postprocessing(py_to_r(x, 1, 1), "simple_triplet_matrix");
    Py_XDECREF(x);
    return(rval);
}

SEXP py_df_to_r_df(PyObject *obj) {
    PyObject *x = PyObject_CallMethod(obj, "to_r", "");
    if ( x == NULL ) {
        Rprintf("py_df_to_r_df is NULL!\n");
        return( R_NilValue );
    }
    SEXP rval = py_to_r_postprocessing(py_to_r(x, 1, 1), "data.frame");
    Py_XDECREF(x);
    return(rval);
}

SEXP py_error_to_r_error(PyObject *obj) {
    PyObject *x = PyObject_CallMethod(obj, "to_r", "");
    if ( x == NULL ) {
        Rprintf("py_error_to_r_error is NULL!\n");
        return( R_NilValue );
    }
    SEXP rval = py_to_r_postprocessing(py_to_r(x, 0, 1), "error");
    Py_XDECREF(x);
    return(rval);
}

int py_to_c_integer(PyObject *py_object){
    long c_long;
    if(PyInt_Check(py_object)){
        c_long = PY_TO_C_INTEGER(py_object);
    }else if(PyLong_Check(py_object)){
        c_long = PY_TO_C_LONG(py_object);
    }else{
        error("in py_to_r_integer!\n");
    }
    return (int)c_long;
}

const char *py_to_c_string(PyObject *py_object){
    const char *c_string;
    if(PyString_Check(py_object)){
        c_string = PY_TO_C_STRING(py_object);
    }else if(PyUnicode_Check(py_object)){
        c_string = PY_TO_C_UNICODE(py_object);
    }else{
        error("in py_to_c_string!\n");
    }
    return c_string;
}

PyObject *py_to_r_typecast(PyObject *py_object, int autotype) {
    PyObject *py_args = PyTuple_New(2);
    PyTuple_SET_ITEM(py_args, 0, py_object);
    PyObject *py_auto = PyBool_FromLong(autotype);
    PyTuple_SET_ITEM(py_args, 1, py_auto);
    PyObject *py_kw = NULL;
    PyObject *py_ret_val = PyObject_Call(PY_To_R_Typecast, py_args, py_kw);
    PyRun_SimpleString("\n");
    if (py_ret_val == NULL) {
        py_ret_val = py_get_py_obj("__R__.PythonInR_Error('while typecasting from Python to R')");
    }
    //Py_XDECREF(py_args);
    //Py_XDECREF(py_object);
    return py_ret_val;
}

SEXP py_to_r_postprocessing(SEXP x, const char *cls) {
    SEXP e;
    int hadError;
    char c_string[MAXELTSIZE+1];
    
    snprintf(c_string, MAXELTSIZE + 1, 
             "PythonInR:::py_to_r_postprocessing[['%s']]", 
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
        Rprintf("an error occurred in py_to_r_postprocessing\n");
    }
    UNPROTECT(1);
    return(r_obj);
}

/*  ----------------------------------------------------------------------------

    py_to_r 
      
    in older version more python types are checked but not converted
  ----------------------------------------------------------------------------*/
SEXP py_to_r(PyObject *pyo, int simplify, int autotype) {
  
    if ( PyNone_Check(pyo) ) return R_NilValue;
    else if ( PyBool_Check(pyo) & autotype )    return PY_TO_R__BOOL(pyo);
    else if ( PyInt_Check(pyo) & autotype )     return PY_TO_R__INT(pyo);
    else if ( PyLong_Check(pyo) & autotype )    return PY_TO_R__LONG(pyo);
    else if ( PyFloat_Check(pyo) & autotype )   return PY_TO_R__DOUBLE(pyo);
    else if ( PyString_Check(pyo) & autotype )  return PY_TO_R__STRING(pyo);
    else if ( PyUnicode_Check(pyo) & autotype ) return PY_TO_R__UNICODE(pyo);
    else if ( Py_Error_Check(pyo) )             return PY_TO_R__ERROR(pyo);
    
    if (!autotype) PY_TO_R__OBJECT(pyo);
    int r_type = py_get_container_type(pyo);

    Rprintf("py_to_r: type=%i\n", r_type);

    switch( r_type ) {
        case 100 : return PY_TO_R__VECTOR(pyo);
        case 120 : return PY_TO_R__TLIST(pyo);
        case 130 : return PY_TO_R__TTUPLE(pyo);
        case 140 : return PY_TO_R__NUMPY_VECTOR(pyo);
        case 200 : return PY_TO_R__MATRIX(pyo);
        case 210 : return PY_TO_R__NUMPY_MATRIX(pyo);
        case 220 : return PY_TO_R__CVXOPT_MATRIX(pyo);
        case 300 : return PY_TO_R__ARRAY(pyo);
        case 310 : return PY_TO_R__NUMPY_ARRAY(pyo);
        case 400 : return PY_TO_R__LIST(pyo);
        case 401 : return PY_TO_R__TUPLE(pyo);
        case 410 : return PY_TO_R__NLTK_TREE(pyo);
        case 420 : return PY_TO_R__SIMPLE_TRIPLET_MATRIX(pyo);
        case 421 : return PY_TO_R__CVXOPT_SPARSE_MATRIX(pyo);
        case 422 : return PY_TO_R__BSR(pyo);
        case 423 : return PY_TO_R__COO(pyo);
        case 424 : return PY_TO_R__CSC(pyo);
        case 425 : return PY_TO_R__CSR(pyo);
        case 426 : return PY_TO_R__DIA(pyo);
        case 427 : return PY_TO_R__DOK(pyo);
        case 428 : return PY_TO_R__LIL(pyo);
        case 430 : return PY_TO_R__DICT(pyo);
        case 500 : return PY_TO_R__DATA_FRAME(pyo);
        case 510 : return PY_TO_R__PANDAS_DATA_FRAME(pyo);
        default  : return PY_TO_R__OBJECT(pyo);
    }
    return PY_TO_R_OBJECT(pyo);
}

SEXP py_to_r__(PyObject *py_object, int simplify, int autotype) {
    SEXP r_val;
    int r_type;
       
    if ( PyNone_Check(py_object) ) {                                            // None
        r_val = R_NilValue;

    } else if ( PyBool_Check(py_object) & autotype ) {                          // Boolean
        int c_boolean;
        c_boolean = PY_TO_C_BOOLEAN(py_object);
        r_val =  c_to_r_boolean(c_boolean);

    } else if ( PyInt_Check(py_object) & autotype ) {                           // Integer
        long c_long;
        c_long = PY_TO_C_INTEGER(py_object);
        r_val = c_to_r_integer(c_long);

    } else if ( PyLong_Check(py_object) & autotype ) {                          // Long
        long c_long;
        c_long = PY_TO_C_LONG(py_object);
        r_val = c_to_r_integer(c_long);

    } else if ( PyFloat_Check(py_object) & autotype ) {                         // Float
        double c_double;
        c_double = PY_TO_C_DOUBLE(py_object);
        r_val = c_to_r_double(c_double);

    } else if ( PyString_Check(py_object) & autotype ) {                        // String
        const char *c_string;
        c_string = PY_TO_C_STRING(py_object);
        r_val = c_to_r_string(c_string);

    } else if ( PyUnicode_Check(py_object) & autotype ) {                       // Unicode
        const char *c_string;
        c_string = PY_TO_C_UNICODE(py_object);
        r_val = c_to_r_unicode(c_string); 

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
        Rprintf("NO type found!\n");
        py_object = py_to_r_typecast(py_object, autotype);
        r_val = py_to_r(py_object, simplify, autotype);
    }
    
    return r_val;
}
