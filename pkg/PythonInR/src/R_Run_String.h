#ifndef PYTHON_IN_R_RUN_STRING
#define PYTHON_IN_R_RUN_STRING

#include "PythonInR.h"
#include "CastRObjects.h"
#include <R_ext/Parse.h>

SEXP r_eval_sexp_string(SEXP code);
SEXP r_eval_string(const char* code);
SEXP r_call_function(SEXP function, SEXP args);
//SEXP r_call_function(const char* function, SEXP args);
SEXP PythonInR_sprintf(const char *fmt, SEXP x);

#endif

