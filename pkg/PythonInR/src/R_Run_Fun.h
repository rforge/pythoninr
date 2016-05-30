#ifndef PYTHON_IN_R_FUN
#define PYTHON_IN_R_FUN

#include "PythonInR.h"
#include "CastRObjects.h"
#include "R_Run_String.h"
#include "CToR.h"

SEXP R_eval_1_arg(const char *cmd, SEXP x);

SEXP Test_R_eval_1_arg(SEXP cmd, SEXP x);

SEXP R_error(const char *message, const char *domain, const char *error_type);

SEXP permute_array_to_numpy(SEXP x);

SEXP Test_permute_array_to_numpy(SEXP x) ;

SEXP permute_array_from_numpy(SEXP x);

SEXP matrix_from_list_byrow(SEXP x);
SEXP matrix_from_list_bycol(SEXP x);
SEXP data_frame_from_list(SEXP x);
SEXP data_frame_from_list2(SEXP x);

#endif

