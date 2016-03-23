
q("no")
R

library("PythonInR")

PythonInR:::pySetSimple("x", cars)
str(cars)
pyExecp("x")
x <- PythonInR:::pyGetSimple("x")
x

setattr(z, '__rclass__', 'data.frame')

if ( is. )





import pandas as pd
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6], 'C':[7,8,9]}, index=["one", "two", "three"])
df
df2 = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6], 'C':[7,8,9]})
dir(df)
z = df.to_dict()
z
z.rclass = lambda: None

df.__class__['__rclass__'] = "Hallo"
 __rclass__
dataFrame, rownames, colnames, dim, dtype

list(df.index)

dir(df)

__R__.dataFrame(x.to_dict(), list(x.index), list(x.keys()), df.shape, None)

pyExecp("type(x)")
pyExecp("x.values")
pyExecp("x.dim")

dim(cars)
dim.data.frame
.row_names_info


shortRowNames

BEGIN.Python()

xself = x
s = "'dataFrame':\n"
offset = max([len(k) for k in xself.values.keys()])
seq = range(0, (min(xself.dim[0], 5)))

for key in xself.values.keys():
    s += "  " + str(key) + (offset - len(str(key))) * " " + ":"
    for i in seq:
        s += " " + str(xself.values[key][i])
    s += "\n"

print(s)