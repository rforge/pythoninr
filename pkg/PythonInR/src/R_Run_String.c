#include "R_Run_String.h"

/*  ----------------------------------------------------------------------------
    
    r_eval_string
     
    Is used to eval R code from Python.

  ----------------------------------------------------------------------------*/
SEXP r_eval_sexp_string(SEXP code) {
    SEXP e, r_obj;
    int hadError;
    ParseStatus status;
   
    PROTECT(e = R_ParseVector(code, 1, &status, R_NilValue));
    r_obj = R_tryEval(VECTOR_ELT(e, 0), R_GlobalEnv, &hadError);
    
    if (hadError){
		UNPROTECT(1);
		Rprintf("an error occurred while executing the follwing expression\n");
		return(R_NilValue);
	}
	UNPROTECT(1);
	return(r_obj);
}
  
SEXP r_eval_string(const char* code){
    SEXP e, tmp, r_obj;
    int hadError;
    ParseStatus status;

    PROTECT(tmp = mkString(code));    
    PROTECT(e = R_ParseVector(tmp, 1, &status, R_NilValue));
    r_obj = R_tryEval(VECTOR_ELT(e, 0), R_GlobalEnv, &hadError);
    
    if (hadError){
		UNPROTECT(2);
		Rprintf("an error occurred while executing the follwing expression\n");
		return(R_NilValue);
	}
	UNPROTECT(2);
	return(r_obj);
}

SEXP r_call_function(SEXP function, SEXP args) {
    SEXP e, r_obj;
    int hadError;
    
    SEXP fun = r_eval_sexp_string(function);
    
    PROTECT(e = allocVector(LANGSXP, GET_LENGTH(args) + 1));
    
    SETCAR(e, fun);
    for (int i=0; i < GET_LENGTH(args); i++) {
		SETCDR(e, VECTOR_ELT(args, i));
	}
	
	CAR(e);
	SEXP names = GET_NAMES(args);
	for (int i=0; i < GET_LENGTH(names); i++) {
		SET_TAG(CDR(e), install(CHAR(STRING_ELT(names, 0))));
	}
	UNPROTECT(1);
	return(e);
	r_obj = R_tryEval(e, NULL, &hadError);
    
    if (hadError){
		UNPROTECT(1);
		Rprintf("an error occurred while executing the follwing expression\n");
		return(R_NilValue);
	}
	UNPROTECT(1);
	return(r_obj);
}

SEXP PythonInR_sprintf(const char *fmt, SEXP x) {
	SEXP e, r_obj;
    int hadError;
    
    SEXP fun = r_eval_string("base::sprintf");
	PROTECT(e = allocVector(LANGSXP, 2));
	SETCAR(e, fun);
	
	SETCADR(e, c_to_r_string(fmt));
    SET_TAG(CDR(e), install("fmt"));
    
    SETCADDR(e, x);
    SET_TAG(CDR(e), install(""));
    
	r_obj = R_tryEval(e, NULL, &hadError);
    
    if (hadError){
		UNPROTECT(1);
		Rprintf("an error occurred while executing the follwing expression\n");
		return(R_NilValue);
	}
	UNPROTECT(1);
	return(r_obj);
}

