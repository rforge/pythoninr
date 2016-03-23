#include "R_Run_Fun.h"

/*  ----------------------------------------------------------------------------
    
    R Function Calls

	Some Help Functions which should make it easier to work with R's High Level
	Functions in C!
  ----------------------------------------------------------------------------*/
  
SEXP R_eval_1_arg(const char *cmd, SEXP x) {
	SEXP e; int hadError;
	SEXP fun = r_eval_string( cmd );
	if ( fun == NULL ) 
		return x;
	
	PROTECT(e = allocVector(LANGSXP, 2));   
    SETCAR(e, fun);

    SETCADR(e, x);
    SET_TAG(CDR(e), install( "x" ));
    SEXP r_obj = R_tryEval(e, NULL, &hadError);
    
    if (hadError) {
		r_obj = R_error(cmd, "R_Run_Fun.c;R_eval_1_arg", "SyntaxError");
	}
	UNPROTECT(1);
	return(r_obj);
}

SEXP Test_R_eval_1_arg(SEXP cmd, SEXP x) {
	const char * c_cmd = R_TO_C_STRING(x);
	return R_eval_1_arg(c_cmd, x);
}

SEXP R_error(const char *message, const char *domain, const char *error_type) {
	SEXP r_list, r_names, class;
	PROTECT(r_list = allocVector(VECSXP, 3));
    PROTECT(r_names = allocVector(VECSXP, 3));
    
    SET_VECTOR_ELT(r_names, 0, c_to_r_string("message"));
    SET_VECTOR_ELT(r_list, 0, c_to_r_string(message));
    
    SET_VECTOR_ELT(r_names, 1, c_to_r_string("domain"));
    SET_VECTOR_ELT(r_list, 1, c_to_r_string(message));
    
    SET_VECTOR_ELT(r_names, 2, c_to_r_string("error_type"));
    SET_VECTOR_ELT(r_list, 2, c_to_r_string(message));
    
    PROTECT(class = allocVector(STRSXP, 2));
    SET_STRING_ELT(class, 0, mkChar("error"));
    SET_STRING_ELT(class, 1, mkChar("PythonInR"));
    
    setAttrib(r_list, R_NamesSymbol, r_names);
    classgets(r_list, c_to_r_string(""));
    
    UNPROTECT(3);
	return r_list;
}

SEXP R_fun_dim(SEXP x) {
	return R_eval_1_arg("dim", x);
}

SEXP R_fun_rownames(SEXP x) {
	return R_eval_1_arg("rownames", x);
}

SEXP R_fun_colnames(SEXP x) {	
	return R_eval_1_arg("colnames", x);
}
