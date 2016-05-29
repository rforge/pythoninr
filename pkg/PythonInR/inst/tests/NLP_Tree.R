q("no")
Rdevel
library(PythonInR)
library(testthat)
library(typehints)
library(NLP)

vp <- Tree('VP', list(Tree('V', list('saw')), Tree('NP', list('him'))))
pySet("x", vp)
pyPrint("x")
pyType("x")


str(pyGet("x"))
str(vp)

Tree_apply
a <- pyGet("x")

nlp_tree_from_list <- function(x) {
	fun <- function(x) {
		x <- x[c('value', 'children')]
		class(x) <- "Tree"
		return(x)
	}
	x <- x[c('value', 'children')]
	x[['children']] <- Tree_apply(x, fun)
	class(x) <- "Tree"
	return(x)
}

str(vp)
str(nlp_tree_from_list(a))

a <- a[c('value', 'children')]
a <- a

str(a)
vp
pyExecp("type(x)")
pyExecp("type(x['children'][0])")
pyExecp("x['children'][0]['children']")

pyExecp("y = x.to_nltk_tree()")
pyExecp("y")
pyExecp("z = __R__.nltk_tree_to_dict(y)")
pyExecp("z")
pyExecp("type(z)")
pyExecp("type(z['children'][0])")
str(pyGet("y"))

library("NLP")
ls("package:NLP")


x

BEGIN.Python()

import collections
dir(collections)
from collections import OrderedDict

{"b": 1, "a": 2}
help("collections")
help("dict")
OrderedDict(b=1, a=2)
dict(b=1)
?dict

from nltk.tree import Tree as nltkTree
from sets import Set
from warnings import warn

warn("nltk package coulnd't be loaded")
warn("nltk package coulnd't be loaded", ImportWarning)

print("")

vp = nltkTree('VP', [nltkTree('V', ['saw']), nltkTree('NP', ['him'])])
vp

dict(x)
xtree = nltkTree(x['value'], [])
xtree
for child in x['children']:
    if is_nlp_tree(child):
        xtree.append(nlp_tree_to_nltk_tree(child))
    else:
        xtree.append(child)

def is_nlp_tree(x):
    if isinstance(x, dict):
        if (len( Set(x.keys()).difference(['children', 'value']) ) == 0):
            return(True)
    return(False)


nlp_tree_to_nltk_tree(x)
vp

def nlp_tree_to_nltk_tree(x):
    xtree = nltkTree(x['value'], [])
    for child in x['children']:
        if is_nlp_tree(child):
            xtree.append(nlp_tree_to_nltk_tree(child))
        else:
            xtree.append(child)
    return(xtree)



END.Python



pluma test.R &
pluma Multiline/pryr/R/draw-tree.r &
plume Multiline/pryr/R/modify-lang.r &
pluma PythonInR/R/C_To_R.R &
pluma PythonInR/R/C_Utility.R &
pluma PythonInR/devel/Reflection/Reflection.R &
pluma PythonInR/devel/Types/testing.R &
pluma R_Forge/pythoninr/pkg/PythonInR/R/C_To_R.R &
pluma R_Forge/pythoninr/pkg/PythonInR/R/C_Utility.R &
pluma R_Forge/pythoninr/pkg/PythonInR/devel/Reflection/Reflection.R &
pluma R_Forge/pythoninr/pkg/PythonInR/devel/Types/testing.R &
pluma tree_to_R.R &
pluma dev/tree_nltk.R &
pluma dev/old/library.R &
pluma dev/Test_NLTK_tree.R &
pluma RD_Manual_Vorlage/openNLP/R/parse.R &
pluma rd2rst/parseRd.R &

ls
mkdir NLP_Tree_dev

cp test.R NLP_Tree_dev/
cp Multiline/pryr/R/draw-tree.r NLP_Tree_dev/
cp Multiline/pryr/R/modify-lang.r NLP_Tree_dev/
cp PythonInR/R/C_To_R.R NLP_Tree_dev/
cp PythonInR/R/C_Utility.R NLP_Tree_dev/
cp PythonInR/devel/Reflection/Reflection.R NLP_Tree_dev/
cp PythonInR/devel/Types/testing.R NLP_Tree_dev/
cp R_Forge/pythoninr/pkg/PythonInR/R/C_To_R.R NLP_Tree_dev/
cp R_Forge/pythoninr/pkg/PythonInR/R/C_Utility.R NLP_Tree_dev/
cp R_Forge/pythoninr/pkg/PythonInR/devel/Reflection/Reflection.R NLP_Tree_dev/
cp R_Forge/pythoninr/pkg/PythonInR/devel/Types/testing.R NLP_Tree_dev/
cp tree_to_R.R NLP_Tree_dev/
cp dev/tree_nltk.R NLP_Tree_dev/
cp dev/old/library.R NLP_Tree_dev/
cp dev/Test_NLTK_tree.R NLP_Tree_dev/
cp RD_Manual_Vorlage/openNLP/R/parse.R NLP_Tree_dev/
cp rd2rst/parseRd.R NLP_Tree_dev/
