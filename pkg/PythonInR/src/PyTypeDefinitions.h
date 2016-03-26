/* --------------------------------------------------------------------------  \

    Create - Constructor Functions for the New Python Objects

\  -------------------------------------------------------------------------- */
#ifndef PYTHON_IN_R_PY_TYPE
#define PYTHON_IN_R_PY_TYPE
 
#include "PythonInR.h"

/*  ----------------------------------------------------------------------------
    PY_VEC.* 
    
    Creates a new object of type PyVector.
    :param PyObject x: an interable (noramlly list) giving the values
    :param PyObject y: an list giving the list
    :return: A new PyVector
    :rtype: PyVector
  ----------------------------------------------------------------------------*/ 
// x ... values    y ... names
#define PY_VEC_BOOL(x, y)    Py_call_2_args("__R__.vecBool", x, y)
#define PY_VEC_INT(x, y)     Py_call_2_args("__R__.vecInt", x, y)
#define PY_VEC_LONG(x, y)    Py_call_2_args("__R__.vecLong", x, y)
#define PY_VEC_FLOAT(x, y)   Py_call_2_args("__R__.vecFloat", x, y)
#define PY_VEC_STRING(x, y)  Py_call_2_args("__R__.vecString", x, y)
#define PY_VEC_UNICODE(x, y) Py_call_2_args("__R__.vecUnicode", x, y)

#define PY_TLIST_BOOL(x)    Py_call_1_arg("__R__.tlistBool", x)
#define PY_TLIST_INT(x)     Py_call_1_arg("__R__.tlistInt", x)
#define PY_TLIST_LONG(x)    Py_call_1_arg("__R__.tlistLong", x)
#define PY_TLIST_FLOAT(x)   Py_call_1_arg("__R__.tlistFloat", x)
#define PY_TLIST_STRING(x)  Py_call_1_arg("__R__.tlistString", x)
#define PY_TLIST_UNICODE(x) Py_call_1_arg("__R__.tlistUnicode", x)

#define PY_TTUPLE_BOOL(x)    Py_call_1_arg("__R__.ttupleBool", x)
#define PY_TTUPLE_INT(x)     Py_call_1_arg("__R__.ttupleInt", x)
#define PY_TTUPLE_LONG(x)    Py_call_1_arg("__R__.ttupleLong", x)
#define PY_TTUPLE_FLOAT(x)   Py_call_1_arg("__R__.ttupleFloat", x)
#define PY_TTUPLE_STRING(x)  Py_call_1_arg("__R__.ttupleString", x)
#define PY_TTUPLE_UNICODE(x) Py_call_1_arg("__R__.ttupleUnicode", x)

#define PY_VEC_TO_NUMPY_ARRAY(x)   Py_call_1_arg("__R__.numpyArray", x)

PyObject *Py_Vec(PyObject *py_li, PyObject *py_names, int r_type);
PyObject *Py_Tlist(PyObject *py_li, int r_type);
PyObject *Py_Ttuple(PyObject *py_li, int r_type);

#define PyVec_Check(x)        Py_call_1_arg("__R__.isVector", x)
#define PyVecBool_Check(x)    Py_call_1_arg("__R__.isVectorBool", x)
#define PyVecInt_Check(x)     Py_call_1_arg("__R__.isVectorInt", x)
#define PyVecLong_Check(x)    Py_call_1_arg("__R__.isVectorLong", x)
#define PyVecFloat_Check(x)   Py_call_1_arg("__R__.isVectorFloat", x)
#define PyVecString_Check(x)  Py_call_1_arg("__R__.isVectorString", x)
#define PyVecUnicode_Check(x) Py_call_1_arg("__R__.isVectorUnicode", x)
   
#endif
