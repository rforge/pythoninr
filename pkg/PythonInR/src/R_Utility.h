/* --------------------------------------------------------------------------  \

    R-Utility Function

\  -------------------------------------------------------------------------- */

#ifndef PYTHON_IN_R_Utility
#define PYTHON_IN_R_Utility

#include "PythonInR.h"
#include "CToR.h"
#include "R_Run_String.h"
#include "PythonObjects.h"

#define HAS_TH_INT(x)       has_typehint(x, "int")
#define HAS_TH_LONG(x)      has_typehint(x, "long")
#define HAS_TH_STRING(x)    has_typehint(x, "string")
#define HAS_TH_UNICODE(x)   has_typehint(x, "unicode")

#define HAS_TH_CONTAINER(x) ( HAS_TH_VECTOR(x) | HAS_TH_LIST(x) | HAS_TH_TLIST(x) | HAS_TH_TUPLE(x) | HAS_TH_NUMPY(x) )
#define HAS_TH_VECTOR(x)    has_typehint(x, "vector")
#define HAS_TH_LIST(x)      has_typehint(x, "list")
#define HAS_TH_TLIST(x)     has_typehint(x, "tlist")
#define HAS_TH_TUPLE(x)     has_typehint(x, "tuple")
#define HAS_TH_TTUPLE(x)    has_typehint(x, "ttuple")
#define HAS_TH_DICT(x)      has_typehint(x, "dict")
#define HAS_TH_NUMPY(x)     has_typehint(x, "numpy")
#define HAS_TH_CVXOPT(x)    has_typehint(x, "cvxopt")

#define HAS_TH_SCI_BSR(x)   has_typehint(x, "scibsr")
#define HAS_TH_SCI_COO(x)   has_typehint(x, "scicoo")
#define HAS_TH_SCI_CSC(x)   has_typehint(x, "scicsc")
#define HAS_TH_SCI_CSR(x)   has_typehint(x, "scicsr")
#define HAS_TH_SCI_DENSE(x) has_typehint(x, "scidense")
#define HAS_TH_SCI_DIA(x)   has_typehint(x, "scidia")
#define HAS_TH_SCI_DOK(x)   has_typehint(x, "scidok")
#define HAS_TH_SCI_LIL(x)   has_typehint(x, "scilil")

#define HAS_TH_PANDAS(x)    has_typehint(x, "pandas")

#define R_TYPE_CHECK(o) ( (o==10) | (o==12) | (o==13) | (o==14) | (o==16) | (o==17) )

#define IS_TREE(x)          compare_r_class(x, "Tree")
#define IS_SLAM(x)          compare_r_class(x, "simple_triplet_matrix")
#define IS_NLIST(x)         ( isNewList(x) & !isNull(GET_NAMES(x)) )

SEXP combine_character(SEXP x, SEXP y);

SEXP r_get_type_name(SEXP x);

SEXP r_get_class_name(SEXP x);

int compare_r_class(SEXP x, const char *className);

int r_GetR_Type(SEXP r_object);

int r_GetR_Container(SEXP x);

SEXP get_typehint(SEXP x);

int has_typehint(SEXP x, const char *type);

SEXP set_typehint(SEXP x, SEXP n);

int add_typehint(SEXP x, const char *type);

SEXP Test_add_typehint(SEXP x, SEXP th);

SEXP get_attributes(SEXP x);
SEXP get_dimension(SEXP x);
SEXP get_names(SEXP x);
SEXP get_type(SEXP x);

#endif

