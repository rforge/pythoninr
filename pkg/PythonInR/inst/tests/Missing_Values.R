q("no")
Rdevel

library(PythonInR)

BEGIN.Python()

float('NaN')
float('Inf')
float('-inf')
is.nan('NaN')
x = float('NaN')
dir(x)

isNaN(x)
import math
math.isnan(x)

class NA_int(int):
    """A Typed tuple Class"""
    def __new__(self, value):
        self.value = 2147483648
        return int.__new__(self, value)

def is_na(x):
    x is NA_int

float('NaN')

n = NA_int()
n


END.Python

x <- as.integer(NA)
x
2147483647
as.integer(2147483648)
as.integer(-2147483648)
-2147483648
