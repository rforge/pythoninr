## Use syntax known form python and C!
## for ( init-expression ; cond-expression ; loop-expression )
library(PythonInR)
pyExec('
def firstn(n):
    num = 0
    while num < n:
        yield num
        num += 1
')

## TODO: define a generator end class!
generator_cmd <-
"
try:
    x = %s.next()
except:
    x = None
"

x <- "firstn(10)"

z <- pyGet(x)
g <- pyObject(z$id)
## todo rename next to nnext or .next or nexxt
unname(pyExecg(sprintf(generator_cmd, z$id)))    

xg <- gen(x)
xg()

foor <- function( generator ) {
    
}

 
