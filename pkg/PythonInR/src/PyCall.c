/* --------------------------------------------------------------------------  \

    PyCall

    Provides functions call R objects from with in R!
    
    NOTE: PyCall should always return a new reference as it does now.
\  -------------------------------------------------------------------------- */

#include "PyCall.h"

SEXP py_call_obj(SEXP r_obj_name, SEXP r_args, SEXP r_kw, SEXP simplify, SEXP auto_typecast){
	SEXP r_object;
    PyObject *py_global, *py_object, *py_args, *py_kw, *py_ret_val;
	 
    // get object (try a very high level approach)
    const char *c_obj_name = R_TO_C_STRING(r_obj_name);
    int autotype = R_TO_C_BOOLEAN(auto_typecast);
    py_global = PyModule_GetDict(PyImport_AddModule("__main__"));
    
    // Py_eval_input, Py_file_input, or Py_single_input
    py_object = PyRun_String(c_obj_name, Py_eval_input, py_global, py_global);
    PyRun_SimpleString("\n");
    
    if (py_object == NULL){
        error("'%s' could not be found!", c_obj_name);
    }
    
    if (PyCallable_Check(py_object) < 1){
		error("'%s' is not callable!", c_obj_name);
    }
    
    // convert the args and kwargs
    // py_args = r_non_nested_list_to_py_tuple(r_args);
    long len_kw = GET_LENGTH(r_kw);
    py_args = r_to_py_tuple(r_args);
    if (len_kw < 1){
        py_kw = NULL;
    }else{
        py_kw = r_to_py_dict(GET_NAMES(r_kw), r_kw);
    }
    
    py_ret_val = PyObject_Call(py_object, py_args, py_kw);
    PyRun_SimpleString("\n");
    
    Py_XDECREF(py_args);
    Py_XDECREF(py_kw);
    Py_XDECREF(py_object);
    
    if (py_ret_val == NULL) error("error occured while calling '%s'", c_obj_name);
    
    int c_simplify = R_TO_C_BOOLEAN(simplify);
    r_object = py_to_r(py_ret_val, c_simplify, autotype);
    Py_XDECREF(py_ret_val);
    PyRun_SimpleString("\n");
    return r_object;
}

PyObject *python_call(const char *c_obj_name, PyObject *py_args, PyObject *py_kw) {
    PyObject *py_global, *py_object, *py_ret_val;
    
    py_global = PyModule_GetDict(PyImport_AddModule("__main__"));
    
    // Py_eval_input, Py_file_input, or Py_single_input
    py_object = PyRun_String(c_obj_name, Py_eval_input, py_global, py_global);
    PyRun_SimpleString("\n");
    
    if (py_object == NULL){
		py_ret_val = Python_error("could not find function", "PyCall.c;python_call", "LookupError");
        return py_ret_val;
    }
    
    if (PyCallable_Check(py_object) < 1){
		py_ret_val = Python_error("object is not callable", "PyCall.c;python_call", "TypeError");
		return py_ret_val;
    }
    py_ret_val =  PyObject_Call(py_object, py_args, py_kw);
    PyRun_SimpleString("\n");
    Py_XDECREF(py_args);
    Py_XDECREF(py_kw);
    // Py_XDECREF(py_object);
    
    if (py_ret_val == NULL) return NULL;
    return py_ret_val;
}

/**
	Python offers different types of error
	see https://docs.python.org/2/library/exceptions.html
**/
PyObject *Python_error(const char *message, const char *domain, const char *error_type) {
	PyObject *attr;
	PyObject *py_error = py_get_py_obj("__R__.PythonInR_Error()");
	attr = PyUnicode_FromString(message);
	PyObject_SetAttrString(py_error, "message", attr);
	attr = PyUnicode_FromString(domain);
	PyObject_SetAttrString(py_error, "domain", attr);
	attr = PyUnicode_FromString(error_type);
	PyObject_SetAttrString(py_error, "error_type", attr);
	return py_error;
}

SEXP Test_Python_error(SEXP message) {
	return py_to_r(Python_error(R_TO_C_STRING(message), "domain", "error_tyoe"), 1, 1);
}

PyObject *Py_call_1_arg(const char *c_obj_name, PyObject *x) {
	PyObject *py_args = PyTuple_New(1);
	PyTuple_SET_ITEM(py_args, 0, x);
	PyObject *pval = python_call(c_obj_name, py_args, NULL);
	return pval;
}

SEXP Test_Py_call_1_arg(SEXP fun_name, SEXP arg) {
	return py_to_r(Py_call_1_arg(R_TO_C_STRING(fun_name), r_to_py(arg)), 0, 1);
}

PyObject *Py_call_2_args(const char *c_obj_name, PyObject *x, PyObject *y) {
	PyObject *py_args = PyTuple_New(2);
	PyTuple_SET_ITEM(py_args, 0, x);
	PyTuple_SET_ITEM(py_args, 1, y);
	PyObject *pval = python_call(c_obj_name, py_args, NULL);
	return pval;
}
