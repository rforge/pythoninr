//#define DEBUG_PYTHONINR
/* --------------------------------------------------------------------------  \

    PythonInR

\  -------------------------------------------------------------------------- */

#ifndef PY_INSIDE_R_H
#define PY_INSIDE_R_H

#ifndef MAXELTSIZE
#define MAXELTSIZE 8192
#endif

// Some global options (GLOPT)
extern long pyrNamespaceCounter;       // TODO: I del this!
extern int GLOPT_INT_TO_LONG;      // FLAG_INT_TO_LONG          (Default is: TRUE)
extern int GLOPT_CHARACTER_TO_UNICODE; // FLAG_CHARACTER_2_UNICODE  (Default is: TRUE)
extern int GLOPT_VECTOR_TO_LIST;       // FLAG_VECTOR_2_LIST        (Default is: FALSE)
extern int GLOPT_VECTOR_TO_TLIST;
extern int use_PY_To_R_Typecast;

#ifdef PYTHON_IN_R_NO_EXPLICIT_LINKING
#include <Python.h> // If you are a Linux user, did you realy install the Python headers? Try "sudo apt-get install python-dev" to fix this! :)
#else
#define STRICT_R_HEADERS // To disable some R code else I get an compile error
#endif

#include <string.h>
//#include <bytesobject.h>

#ifdef __unix__ /* __unix__ is usually defined by compilers targeting Unix systems */
    #include <dlfcn.h>
#elif defined _WIN32 /* _Win32 is usually defined by compilers targeting 32 or 64 bit Windows systems */
    #include <windows.h>
#endif

#undef SIZEOF_SIZE_T 
#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>
#include <R_ext/Arith.h>

#ifdef DEBUG_PYTHONINR
#include <stdio.h>
#include <errno.h>
//static FILE * log_file;
#define logging(M, ...) fprintf(log_file, "[INFO] (%s:%d) " M "\n", __FILE__, __LINE__, ##__VA_ARGS__); fflush(log_file); 
#else
#define logging(M, ...)
#endif

#ifndef PYTHON_IN_R_NO_EXPLICIT_LINKING
#include <winbase.h>
HMODULE py_hdll;
#include "Python_Explicit_Linking.h" // typedef all the functions needed!
#endif

#include "PythonInRMacros.h"
#include "GetPyObjects.h"
#include "CastPyObjects.h"
#include "CToR.h"

#define PIR_INT_MIN INT_MIN // INT_MIN is NA!
#define PIR_INT_MAX INT_MAX
#define IS_RVECTOR(x) ( IS_LOGICAL(x) || IS_INTEGER(x) || IS_NUMERIC(x) || IS_CHARACTER(x) || isComplex(x) )
#define R_VEC_GET(x, i) ( ( IS_LOGICAL(x) ) ? LOGICAL(x)[i] : ( ( IS_INTEGER(x) ) ? INTEGER(x)[i] : ( ( IS_NUMERIC(x) ) ? REAL(x)[i] : ( ( IS_CHARACTER(x) ) ? STRING_ELT(x, i) : ( ( isComplex(x) ) ? COMPLEX(x)[i] )))))

PyObject* log_write(PyObject*, PyObject*);
PyObject* log_flush(PyObject*, PyObject*);
extern PyObject* PY_To_R_Typecast;

extern PyObject* py_numpy_type;
extern PyObject* py_scipy_type;
extern PyObject* py_nltk_tree_type;

extern SEXP PY_TO_R_POSTPROCESSING;
extern SEXP R_TO_PY_PREPROCESSING;

// NOTE: IS_NUMPY_ARRAY always returns FALSE if numpy is not installed
#define IS_NUMPY_ARRAY(x) (py_numpy_type == NULL) ? 0 : PyObject_IsInstance(x, py_numpy_type)
#define IS_SCIPY_MATRIX(x) (py_scipy_type == NULL) ? 0 : PyObject_IsInstance(x, py_scipy_type)
#define IS_NLTK_TREE(x) (py_nltk_tree_type == NULL) ? 0 : PyObject_IsInstance(x, py_nltk_tree_type)

#ifdef PYTHON_IN_R_NO_EXPLICIT_LINKING
SEXP py_connect(SEXP);
#else
SEXP py_connect(SEXP, SEXP, SEXP);

SEXP py_set_major_version(SEXP);

SEXP py_free_dll(void);

SEXP py_initialize(SEXP);

int py_get_api_version(void);

SEXP py_import_append_logCatcher(void);

SEXP py_init_redirect_stderrout(void);

SEXP py_init_py_values(void);

SEXP py_get_process_addresses(void);

SEXP py_set_program_name(SEXP);

SEXP py_set_home(SEXP pythonHome);

#endif

SEXP py_is_connected(void);

SEXP isDllVersion(void);

SEXP py_get_info(void);

SEXP py_close(void);

#endif
