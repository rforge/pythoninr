#ifndef PYTHON_IN_R_FUN
#define PYTHON_IN_R_FUN

#include "PythonInR.h"
#include "CastRObjects.h"
#include "R_Run_String.h"
#include "CToR.h"

SEXP R_eval_1_arg(const char *cmd, SEXP x);

SEXP Test_R_eval_1_arg(SEXP cmd, SEXP x);

SEXP R_error(const char *message, const char *domain, const char *error_type);

SEXP R_fun_dim(SEXP x);

SEXP R_fun_rownames(SEXP x);

SEXP R_fun_colnames(SEXP x);

#endif

