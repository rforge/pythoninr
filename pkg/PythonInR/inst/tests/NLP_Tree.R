q("no")
Rdevel
library(PythonInR)
library(testthat)
library(typehints)
library(NLP)

vp <- Tree('VP', list(Tree('V', list('saw')), Tree('NP', list('him'))))
vp
pySet("x", vp)
pyPrint("x")













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
