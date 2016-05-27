/* --------------------------------------------------------------------------  \

    R-Utility Function

\  -------------------------------------------------------------------------- */

#include "R_Utility.h"

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

SEXP r_get_type_name(SEXP x) {
    SEXP klass = R_NilValue;
    if ( IS_LOGICAL(x)   ) klass = c_to_r_string("logical");
    if ( IS_INT(x)       ) klass = c_to_r_string("int");
    if ( IS_LONG(x)      ) klass = c_to_r_string("long");
    if ( IS_NUMERIC(x)   ) klass = c_to_r_string("numeric");
    if ( IS_STRING(x)    ) klass = c_to_r_string("string");
    if ( IS_UNICODE(x)   ) klass = c_to_r_string("unicode");
    if ( isComplex(x)    ) klass = c_to_r_string("complex");
    return( klass );
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

int compare_r_class(SEXP x, const char *className) {
    int retVal = 0;
    SEXP cls = getAttrib(x, R_ClassSymbol);
    if (IS_CHARACTER(cls)){
        retVal = (strcmp(R_TO_C_STRING_V(cls, 0), className) == 0);
    }
    return retVal;
}

/*  ----------------------------------------------------------------------------

    r_GetR_Type 
      returns the integer which is needed for R vector allocation

  ----------------------------------------------------------------------------*/
int r_GetR_Type(SEXP r_object) {
    if ( IS_LOGICAL(r_object) ) {
        return 10; /** LGLSXP **/
        
    } else if ( IS_INTEGER(r_object) ) {
        if ( has_typehint(r_object, "int") | !r_int_to_py_long_flag ) {
            return 12;
        } else {
            return 13; /** INTSXP; **/
        }
        
    } else if ( IS_NUMERIC(r_object) ) {
        return 14;  /** REALSXP; **/
    
    } else if ( IS_CHARACTER(r_object) ) {
        if ( has_typehint(r_object, "string") | !r_character_to_py_unicode_flag ) {
            return 16; /** STRSXP; **/
        } else {
            return 17; /** Unicode **/
        }
        
    } else if ( isComplex(r_object) ) {
        error("ValueError: the transformation of objects of type complex is not implemented yet!");
        return 15;
    }
    
    return -1;
}

/*
v <- c(1, 2)   ## IS_NUMERIC; IS_LIST; isVector; isVectorAtomic
m <- matrix(1) ## IS_NUMERIC; IS_LIST; isArray; isMatrix; isVector; isVectorAtomic
a <- array(1)  ## IS_NUMERIC; IS_LIST; isArray; isVector; isVectorAtomic
l <- list(1)   ## IS_LIST; isNewList; isVector; isVectorList
*/
/** *************************************
 *  Types
    * 100 Vector => Vector
    * 110 Vector => List
    * 120 Vec
    * 200 Matrix
    * 300 Array
    * 400 List
    * 500 Data.Frame
    * 600 Environment
 ** ************************************/
int r_GetR_Container(SEXP x) {
    if ( isPyInR_PyObject(x) ) return 700;
    if ( IS_LIST(x) ) {
        if ( isArray(x) ) {
            if ( isMatrix(x) ) {
                if ( HAS_TH_LIST(x) )   return 210;
                if ( HAS_TH_NUMPY(x) )  return 220;
                if ( HAS_TH_CVXOPT(x) ) return 230;
                return 200; /** Matrix **/
            }
            
            if ( HAS_TH_NUMPY(x) ) return 310;
            return 300; /** Array **/
            
        } else if ( isNewList(x) ) {
            if ( isFrame(x) )  return 500; /** Data.Frame **/
            if ( IS_TREE(x) )  return 410; /** NLP.Tree **/
            if ( IS_SLAM(x) ) {
                if ( HAS_TH_CVXOPT(x)    ) return 421;
                if ( HAS_TH_SCI_BSR(x)   ) return 422;
                if ( HAS_TH_SCI_COO(x)   ) return 423;
                if ( HAS_TH_SCI_CSC(x)   ) return 424;
                if ( HAS_TH_SCI_CSR(x)   ) return 425;
                if ( HAS_TH_SCI_DENSE(x) ) return 426;
                if ( HAS_TH_SCI_DIA(x)   ) return 427;
                if ( HAS_TH_SCI_DOK(x)   ) return 428;
                if ( HAS_TH_SCI_LIL(x)   ) return 429;
                return 420; /** simple_triplet_matrix **/
                
            }
            if ( IS_NLIST(x) ) return 430; /** Named List **/
            return 400; /** List **/
            
        } else if ( isVector(x) ) {
            if ( (GET_LENGTH(x) == 1) & !HAS_TH_CONTAINER(x) ) return 110; /** Scalar **/
            if ( HAS_TH_LIST(x) )  return 120; /** Vector + th.list **/
            if ( HAS_TH_TUPLE(x) ) return 130; /** Vector + th.tuple **/
            if ( HAS_TH_NUMPY(x) ) return 140; /** Vector + th.numpy **/
            return 100; /** Vector **/
        }
    }
    
    if ( isEnvironment(x) ) {
        return 600; /** Environment **/
    }
    
    return 0; // TODO;
}

int has_typehint(SEXP x, const char *type){
    int retVal = 0;
    SEXP typehint = get_typehint(x);
    if ( !isNull(typehint) ) {
        for (int i=0; i < GET_LENGTH(typehint); i++ ) {
            if ( strcmp(R_TO_C_STRING_V(typehint, i), type) == 0 ) {
                retVal = 1;
            }
        }
    }
    return retVal;
}

SEXP get_typehint(SEXP x) {
    SEXP typehint = getAttrib(x, install("comment"));
    if ( IS_CHARACTER(typehint) ) return typehint;
    return R_NilValue;
}

SEXP set_typehint(SEXP x, SEXP n) {
    SET_ATTR(x, install("comment"), n);
    return x;
}

int add_typehint(SEXP x, const char *type) {
    SEXP th = combine_character(get_typehint(x), c_to_r_string(type));
    set_typehint(x, th);
    return 0;
}

SEXP Test_add_typehint(SEXP x, SEXP th) {
    add_typehint(x, R_TO_C_STRING(th));
    return x;
}

