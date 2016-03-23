
q("no")
R

library("PythonInR")

dim(cars )

for (i in 1:1000) {
	.Call("R_fun_dim", cars)
}

