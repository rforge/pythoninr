
library(PythonInR)
source("utility.R")

test_vector <- function() {
    domain <- "test_vector"
    ## ---------------------------
    ## NULL
    ## ---------------------------
    pySet("x", NULL)
    expect_equal("test_vector@001", pyType("x"), "NoneType")
    expect_equal("test_vector@002", pyGet("x"), NULL)

    pySet("x", Inf)
    expect_equal("test_vector@003", pyType("x"), "float")
    expect_equal("test_vector@004", pyGet("x"), Inf)

    pySet("x", -Inf)
    expect_equal("test_vector@005", pyType("x"), "float")
    expect_equal("test_vector@006", pyGet("x"), -Inf)

    pySet("x", NA) ## FIXME:
    pyPrint("x")
    expect_equal("test_vector@007", pyType("x"), "NoneType")
    expect_equal("test_vector@008", pyGet("x"), NULL)

    ## ---------------------------
    ## Basic Types
    ## ---------------------------
    ## logical
    pySet("x", TRUE)
    expect_equal("test_vector@009", pyType("x"), "bool")
    expect_equal("test_vector@010", pyGet("x"), TRUE)

    ## int
    pySet("x", th.int(0L))
    expect_equal("test_vector@011", pyType("x"), "int")
    expect_equal("test_vector@012", pyGet("x"), 0L)

    ## long
    pySet("x", 0L)
    expect_equal("test_vector@013", pyType("x"), "long")
    expect_equal("test_vector@014", pyGet("x"), 0L)

    ## double
    pySet("x", 0)
    expect_equal("test_vector@015", pyType("x"), "float")
    expect_equal("test_vector@016", pyGet("x"), 0)

    ## string
    pySet("x", th.string(""))
    expect_equal("test_vector@017", pyType("x"), "str")
    expect_equal("test_vector@018", pyGet("x"), "")

    ## unicode
    pySet("x", "")
    expect_equal("test_vector@019", pyType("x"), "unicode")
    expect_equal("test_vector@020", pyGet("x"), "")

    ## ---------------------------
    ## vector (N=1)
    ## ---------------------------
    ## logical
    pySet("x", th.vector(TRUE))
    expect_equal("test_vector@021", pyType("x"), "PythonInR.vector")
    check("test_vector@022", pyGet("x.dtype is bool"))
    expect_equal("test_vector@023", pyGet("x"), TRUE)

    ## int ## FIXME: (TODO: ich muss noch zusätzliche type hints erstellen )
    ## th.vector_int
    ## pySet("x", th.vector(th.int(0L)))
    pySet("x", th.vector_int(0L))
    expect_equal("test_vector@024", pyType("x"), "PythonInR.vector")
    check("test_vector@025", pyGet("x.dtype is int"))
    expect_equal("test_vector@026", pyGet("x"), 0L)

    ## long
    pySet("x", th.vector(0L))
    expect_equal("test_vector@027", pyType("x"), "PythonInR.vector")
    check("test_vector@028", pyGet("x.dtype is long"))
    expect_equal("test_vector@029", pyGet("x"), 0L)

    ## double
    pySet("x", th.vector(0))
    expect_equal("test_vector@030", pyType("x"), "PythonInR.vector")
    check("test_vector@031", pyGet("x.dtype is float"))
    expect_equal("test_vector@032", pyGet("x"), 0)

    ## string ## FIXME:
    pySet("x", th.vector_str(""))
    expect_equal("test_vector@033", pyType("x"), "PythonInR.vector")
    check("test_vector@034", pyGet("x.dtype is str"))
    expect_equal("test_vector@035", pyGet("x"), "")

    ## unicode
    pySet("x", th.vector(""))
    expect_equal("test_vector@036", pyType("x"), "PythonInR.vector")
    check("test_vector@037", pyGet("x.dtype is unicode"))
    expect_equal("test_vector@038", pyGet("x"), "")

    ## ---------------------------
    ## vector (N>1)
    ## ---------------------------
    ## logical
    pySet("x", c(TRUE, FALSE, TRUE))
    expect_equal("test_vector@039", pyType("x"), "PythonInR.vector")
    check("test_vector@040", pyGet("x.dtype is bool"))
    expect_equal("test_vector@041", pyGet("x"), c(TRUE, FALSE, TRUE))

    ## int ## FIXME:
    pySet("x", th.int(-3:3))
    expect_equal("test_vector@042", pyType("x"), "PythonInR.vector")
    ## pyExecp("x")
    check("test_vector@043", pyGet("x.dtype is int"))
    expect_equal("test_vector@044", pyGet("x"), -3:3)

    ## long
    pySet("x", -3:3)
    expect_equal("test_vector@045", pyType("x"), "PythonInR.vector")
    check("test_vector@046", pyGet("x.dtype is long"))
    expect_equal("test_vector@047", pyGet("x"), -3:3)

    ## double
    pySet("x", as.double(-300:300))
    expect_equal("test_vector@048", pyType("x"), "PythonInR.vector")
    check("test_vector@050", pyGet("x.dtype is float"))
    expect_equal("test_vector@051", pyGet("x"), as.double(-300:300))

    ## string (empty)
    pySet("x", th.string(rep("", 100)))
    expect_equal("test_vector@052", pyType("x"), "PythonInR.vector")
    check("test_vector@053", pyGet("x.dtype is str"))
    expect_equal("test_vector@054", pyGet("x"), rep("", 100))

    ## string (latin1)
    pySet("x", th.string(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@055", pyType("x"), "PythonInR.vector")
    check("test_vector@056", pyGet("x.dtype is str"))
    expect_equal("test_vector@057", pyGet("x"), rep("Hällö Wörld!", 100))

    ## unicode
    pySet("x", rep("Hällö Wörld!", 100))
    expect_equal("test_vector@058", pyType("x"), "PythonInR.vector")
    check("test_vector@059", pyGet("x.dtype is unicode"))
    expect_equal("test_vector@060", pyGet("x"), rep("Hällö Wörld!", 100))

    ## ---------------------------
    ## tlist (N=1) (FIXME)
    ## ---------------------------
    ## logical
    pySet("x", th.tlist(TRUE))
    expect_equal("test_vector@061", pyType("x"), "tlist")
    check("test_vector@062", pyGet("x.dtype is bool"))
    expect_equal("test_vector@063", pyGet("x"), TRUE)

    ## int #FIXME
    pySet("x", th.tlist_int(0L))
    expect_equal("test_vector@064", pyType("x"), "tlist")
    pyExecp("x")
    check("test_vector@065", pyGet("x.dtype is int"))
    expect_equal("test_vector@066", pyGet("x"), 0L)

    ## long
    pySet("x", th.tlist(0L))
    expect_equal("test_vector@067", pyType("x"), "tlist")
    check("test_vector@068", pyGet("x.dtype is long"))
    expect_equal("test_vector@069", pyGet("x"), 0L)

    ## double
    pySet("x", th.tlist(0))
    expect_equal("test_vector@070", pyType("x"), "tlist")
    check("test_vector@071", pyGet("x.dtype is float"))
    expect_equal("test_vector@072", pyGet("x"), 0)

    ## string # FIXME:
    pySet("x", th.tlist_str(""))
    expect_equal("test_vector@073", pyType("x"), "tlist")
    check("test_vector@074", pyGet("x.dtype is str"))
    expect_equal("test_vector@075", pyGet("x"), "")

    ## unicode
    pySet("x", th.tlist("äöü"))
    expect_equal("test_vector@076", pyType("x"), "tlist")
    check("test_vector@077", pyGet("x.dtype is unicode"))
    expect_equal("test_vector@078", pyGet("x"), "äöü")

    ## ---------------------------
    ## tlist (N>1) (FIXME)
    ## ---------------------------
    ## logical
    pySet("x", th.list(c(TRUE, FALSE, TRUE)))
    expect_equal("test_vector@079", pyType("x"), "list")
    expect_equal("test_vector@080", pyType("x[0]"), "bool")
    expect_equal("test_vector@081", pyGet("x"), c(TRUE, FALSE, TRUE))

    ## int
    pySet("x", th.list_int(-3:3))
    expect_equal("test_vector@082", pyType("x"), "list")
    #pyExecp("x")
    check("test_vector@083", pyGet("type(x[0]) is int"))
    expect_equal("test_vector@084", pyGet("x"), -3:3)

    ## long
    pySet("x", th.list(-3:3))
    expect_equal("test_vector@085", pyType("x"), "list")
    check("test_vector@086", pyGet("type(x[0]) is long"))
    expect_equal("test_vector@087", pyGet("x"), -3:3)

    ## double
    pySet("x", th.list(as.double(-3:3)))
    expect_equal("test_vector@088", pyType("x"), "list")
    check("test_vector@089", pyGet("type(x[0]) is float"))
    expect_equal("test_vector@090", pyGet("x"), as.double(-3:3))

    ## string (empty)
    pySet("x", th.list_str(rep("", 30)))
    expect_equal("test_vector@091", pyType("x"), "list")
    check("test_vector@092", pyGet("type(x[0]) is str"))
    expect_equal("test_vector@093", pyGet("x"), rep("", 30))

    ## string (latin1)
    pySet("x", th.list_str(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@094", pyType("x"), "list")
    check("test_vector@095", pyGet("type(x[0]) is str"))
    expect_equal("test_vector@096", pyGet("x"), rep("Hällö Wörld!", 100))

    ## unicode
    pySet("x", th.list(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@097", pyType("x"), "list")
    check("test_vector@098", pyGet("type(x[0]) is unicode"))
    expect_equal("test_vector@099", pyGet("x"), rep("Hällö Wörld!", 100))


    ## ---------------------------
    ## list (N=1)
    ## ---------------------------
    ## logical
    pySet("x", th.list(TRUE))
    expect_equal("test_vector@100", pyType("x"), "list")
    expect_equal("test_vector@101", pyGet("x", simplify=TRUE), TRUE)
    expect_equal("test_vector@102", pyGet("x", simplify=FALSE), list(TRUE))

    ## int
    pySet("x", th.list_int(0L))
    expect_equal("test_vector@103", pyType("x"), "list")
    check("test_vector@104", pyGet("type(x[0]) is int"))
    expect_equal("test_vector@105", pyGet("x"), 0L)

    ## long
    pySet("x", th.list(0L))
    expect_equal("test_vector@106", pyType("x"), "list")
    check("test_vector@107", pyGet("type(x[0]) is long"))
    expect_equal("test_vector@108", pyGet("x"), 0L)

    ## double
    pySet("x", th.list(0))
    expect_equal("test_vector@109", pyType("x"), "list")
    check("test_vector@110", pyGet("type(x[0]) is float"))
    expect_equal("test_vector@111", pyGet("x"), 0)

    ## string
    pySet("x", th.list_str(""))
    expect_equal("test_vector@112", pyType("x"), "list")
    check("test_vector@113", pyGet("type(x[0]) is str"))
    expect_equal("test_vector@114", pyGet("x"), "")

    ## unicode
    pySet("x", th.list("äöü"))
    expect_equal("test_vector@115", pyType("x"), "list")
    check("test_vector@116", pyGet("type(x[0]) is unicode"))
    expect_equal("test_vector@117", pyGet("x"), "äöü")

    ## ---------------------------
    ## list (N>1)
    ## ---------------------------
    ## logical
    pySet("x", th.list(c(TRUE, FALSE, TRUE)))
    expect_equal("test_vector@118", pyType("x"), "list")
    check("test_vector@119", pyGet("type(x[0]) is bool"))
    expect_equal("test_vector@120", pyGet("x"), c(TRUE, FALSE, TRUE))

    ## int
    pySet("x", th.list_int(-3:3))
    expect_equal("test_vector@121", pyType("x"), "list")
    check("test_vector@122", pyGet("type(x[0]) is int"))
    expect_equal("test_vector@123", pyGet("x"), -3:3)

    ## long
    pySet("x", th.list(-3:3))
    expect_equal("test_vector@124", pyType("x"), "list")
    check("test_vector@125", pyGet("type(x[0]) is long"))
    expect_equal("test_vector@126", pyGet("x"), -3:3)

    ## double
    pySet("x", th.list(as.double(-3:3)))
    expect_equal("test_vector@127", pyType("x"), "list")
    check("test_vector@128", pyGet("type(x[0]) is float"))
    expect_equal("test_vector@129", pyGet("x"), as.double(-3:3))

    ## string (empty)
    pySet("x", th.list_str(rep("", 30)))
    expect_equal("test_vector@130", pyType("x"), "list")
    check("test_vector@131", pyGet("type(x[0]) is str"))
    expect_equal("test_vector@132", pyGet("x"), rep("", 30))

    ## string (latin1)
    pySet("x", th.list_str(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@133", pyType("x"), "list")
    check("test_vector@134", pyGet("type(x[0]) is str"))
    expect_equal("test_vector@135", pyGet("x"), rep("Hällö Wörld!", 100))

    ## unicode
    pySet("x", th.list(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@136", pyType("x"), "list")
    check("test_vector@137", pyGet("type(x[0]) is unicode"))
    expect_equal("test_vector@138", pyGet("x"), rep("Hällö Wörld!", 100))

    ## ---------------------------
    ## tuple (N=1)
    ## ---------------------------
    ## logical
    pySet("x", th.tuple(TRUE))
    expect_equal("test_vector@139", pyType("x"), "tuple")
    check("test_vector@140", pyGet("type(x[0]) is bool"))
    expect_equal("test_vector@141", pyGet("x"), TRUE)

    ## int
    pySet("x", th.tuple_int(0L))
    expect_equal("test_vector@142", pyType("x"), "tuple")
    check("test_vector@143", pyGet("type(x[0]) is int"))
    expect_equal("test_vector@144", pyGet("x"), 0L)

    ## long
    pySet("x", th.tuple(0L))
    expect_equal("test_vector@145", pyType("x"), "tuple")
    check("test_vector@146", pyGet("type(x[0]) is long"))
    expect_equal("test_vector@147", pyGet("x"), 0L)

    ## double
    pySet("x", th.tuple(0))
    expect_equal("test_vector@148", pyType("x"), "tuple")
    check("test_vector@149", pyGet("type(x[0]) is float"))
    expect_equal("test_vector@150", pyGet("x"), 0)

    ## string
    pySet("x", th.tuple_str(""))
    expect_equal("test_vector@152", pyType("x"), "tuple")
    ## pyExecp("x[0]")
    ## pyExecp("type(x[0])")  ## FIXME
    check("test_vector@153", pyGet("type(x[0]) is str"))
    expect_equal("test_vector@154", pyGet("x"), "")

    ## unicode
    pySet("x", th.tuple("äöü"))
    expect_equal("test_vector@155", pyType("x"), "tuple")
    check("test_vector@156", pyGet("type(x[0]) is unicode"))
    expect_equal("test_vector@157", pyGet("x"), "äöü")

    ## ---------------------------
    ## tuple (N>1)
    ## ---------------------------
    ## logical
    pySet("x", th.tuple(c(TRUE, FALSE, TRUE)))
    expect_equal("test_vector@158", pyType("x"), "tuple")
    check("test_vector@159", pyGet("type(x[0]) is bool"))
    expect_equal("test_vector@160", pyGet("x"), c(TRUE, FALSE, TRUE))

    ## int
    pySet("x", th.tuple_int(-3:3))
    expect_equal("test_vector@161", pyType("x"), "tuple")
    ##pyExecp("x")
    check("test_vector@162", pyGet("type(x[0]) is int"))
    expect_equal("test_vector@163", pyGet("x"), -3:3)

    ## long
    pySet("x", th.tuple(-3:3))
    expect_equal("test_vector@164", pyType("x"), "tuple")
    check("test_vector@165", pyGet("type(x[0]) is long"))
    expect_equal("test_vector@166", pyGet("x"), -3:3)

    ## double
    pySet("x", th.tuple(as.double(-3:3)))
    expect_equal("test_vector@167", pyType("x"), "tuple")
    check("test_vector@168", pyGet("type(x[0]) is float"))
    expect_equal("test_vector@169", pyGet("x"), as.double(-3:3))

    ## string (empty)
    pySet("x", th.tuple_str(rep("", 30)))
    expect_equal("test_vector@170", pyType("x"), "tuple")
    ##pyExecp("x[0]")
    check("test_vector@171", pyGet("type(x[0]) is str")) ## FIXME
    expect_equal("test_vector@172", pyGet("x"), rep("", 30))

    ## string (latin1)
    pySet("x", th.tuple_str(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@173", pyType("x"), "tuple")
    check("test_vector@174", pyGet("type(x[0]) is str")) ## FIXME
    expect_equal("test_vector@174", pyGet("x"), rep("Hällö Wörld!", 100))

    ## unicode
    pySet("x", th.tuple(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@175", pyType("x"), "tuple")
    check("test_vector@176", pyGet("type(x[0]) is unicode"))
    expect_equal("test_vector@177", pyGet("x"), rep("Hällö Wörld!", 100))

    ## ---------------------------
    ## numpy (N=1)
    ## ---------------------------
    ## logical
    pySet("x", th.numpy(TRUE))
    expect_equal("test_vector@178", pyType("x"), "ndarray")
    expect_equal("test_vector@179", pyGet("x.dtype.kind"), "b")
    expect_equal("test_vector@180", pyGet("x"), TRUE)

    ## int
    ## th.int_numpy ## FIXME: int type for ndarray!
    pySet("x", th.numpy(0L))
    expect_equal("test_vector@181", pyType("x"), "ndarray")
    expect_equal("test_vector@182", pyGet("x.dtype.kind"), "i")
    expect_equal("test_vector@183", pyGet("x"), 0L)

    ## long
    pySet("x", th.numpy(0L))
    expect_equal("test_vector@184", pyType("x"), "ndarray")
    expect_equal("test_vector@185", pyGet("x.dtype.kind"), "i")
    expect_equal("test_vector@186", pyGet("x"), 0L)

    ## double
    pySet("x", th.numpy(0))
    expect_equal("test_vector@187", pyType("x"), "ndarray")
    expect_equal("test_vector@188", pyGet("x.dtype.kind"), "f")
    expect_equal("test_vector@189", pyGet("x"), 0)

    ## string
    pySet("x", th.numpy(""))
    expect_equal("test_vector@190", pyType("x"), "ndarray")
    expect_equal("test_vector@191", pyGet("x.dtype.kind"), "U")
    expect_equal("test_vector@192", pyGet("x"), "")

    ## unicode
    pySet("x", th.numpy("äöü"))
    expect_equal("test_vector@193", pyType("x"), "ndarray")
    expect_equal("test_vector@194", pyGet("x.dtype.kind"), "U")
    expect_equal("test_vector@195", pyGet("x"), "äöü")

    ## ---------------------------
    ## numpy (N>1)
    ## ---------------------------
    ## logical
    pySet("x", th.numpy(c(TRUE, FALSE, TRUE)))
    expect_equal("test_vector@196", pyType("x"), "ndarray")
    expect_equal("test_vector@197", pyGet("x.dtype.kind"), "b")
    expect_equal("test_vector@198", pyGet("x"), c(TRUE, FALSE, TRUE))

    ## int
    pySet("x", th.numpy(-3:3))
    expect_equal("test_vector@199", pyType("x"), "ndarray")
    expect_equal("test_vector@200", pyGet("x.dtype.kind"), "i")
    expect_equal("test_vector@201", pyGet("x"), -3:3)

    ## long
    pySet("x", th.numpy(-3:3))
    expect_equal("test_vector@202", pyType("x"), "ndarray")
    expect_equal("test_vector@203", pyGet("x.dtype.kind"), "i")
    expect_equal("test_vector@204", pyGet("x"), -3:3)

    ## double
    pySet("x", th.numpy(as.double(-3:3)))
    expect_equal("test_vector@204", pyType("x"), "ndarray")
    expect_equal("test_vector@205", pyGet("x.dtype.kind"), "f")
    expect_equal("test_vector@206", pyGet("x"), as.double(-3:3))

    ## string (empty)
    pySet("x", th.numpy(rep("", 30)))
    expect_equal("test_vector@207", pyType("x"), "ndarray")
    expect_equal("test_vector@208", pyGet("x.dtype.kind"), "U")
    expect_equal("test_vector@209", pyGet("x"), rep("", 30))

    ## string (latin1)
    pySet("x", th.numpy(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@210", pyType("x"), "ndarray")
    expect_equal("test_vector@211", pyGet("x.dtype.kind"), "U")
    expect_equal("test_vector@212", pyGet("x"), rep("Hällö Wörld!", 100))

    ## unicode
    pySet("x", th.numpy(rep("Hällö Wörld!", 100)))
    expect_equal("test_vector@213", pyType("x"), "ndarray")
    expect_equal("test_vector@214", pyGet("x.dtype.kind"), "U")
    expect_equal("test_vector@215", pyGet("x"), rep("Hällö Wörld!", 100))

}

test_vector()