/* --------------------------------------------------------------------------  \

    PyTypeDefinitions

\  -------------------------------------------------------------------------- */

#include "PyTypeDefinitions.h"

PyObject *Py_Vec(PyObject *py_li, PyObject *py_names, int r_type) {
	if ( r_type == 10 ) return PY_VEC_BOOL(py_li, py_names);
	if ( r_type == 12 ) return PY_VEC_INT(py_li, py_names);
	if ( r_type == 13 ) return PY_VEC_LONG(py_li, py_names);
	if ( r_type == 14 ) return PY_VEC_FLOAT(py_li, py_names);
	if ( r_type == 16 ) return PY_VEC_STRING(py_li, py_names);
	if ( r_type == 17 ) return PY_VEC_UNICODE(py_li, py_names);
	return py_li;
}

PyObject *Py_Tlist(PyObject *py_li, int r_type) {
	if ( r_type == 10 ) return PY_TLIST_BOOL(py_li);
	if ( r_type == 12 ) return PY_TLIST_INT(py_li);
	if ( r_type == 13 ) return PY_TLIST_LONG(py_li);
	if ( r_type == 14 ) return PY_TLIST_FLOAT(py_li);
	if ( r_type == 16 ) return PY_TLIST_STRING(py_li);
	if ( r_type == 17 ) return PY_TLIST_UNICODE(py_li);
	return py_li;
}

PyObject *Py_Ttuple(PyObject *py_li, int r_type) {
	if ( r_type == 10 ) return PY_TTUPLE_BOOL(py_li);
	if ( r_type == 12 ) return PY_TTUPLE_INT(py_li);
	if ( r_type == 13 ) return PY_TTUPLE_LONG(py_li);
	if ( r_type == 14 ) return PY_TTUPLE_FLOAT(py_li);
	if ( r_type == 16 ) return PY_TTUPLE_STRING(py_li);
	if ( r_type == 17 ) return PY_TTUPLE_UNICODE(py_li);
	return py_li;
}
