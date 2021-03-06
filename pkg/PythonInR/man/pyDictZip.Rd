% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PyObjectDict.R
\name{pyDictZip}
\alias{pyDictZip}
\title{Create a dictionary}
\usage{
pyDictZip(keys, values, regFinalizer = TRUE)
}
\arguments{
\item{keys}{a list giving the keys of the Python object.}

\item{values}{a list giving the values of the Python object.}

\item{regFinalizer}{a logical indicating if a finalizer should be
be registered, the default value is TRUE.}
}
\description{
The function pyDictZip creates a dictionary based on a
             list of keys and a list of values.
}
\details{
If no value is provided a virtual Python dict for an existing
         Python object is created. If the value is NULL, an empty 
         virtual Python object for an empty dict is created.
         If the value is a named vector or named list, a new Python
         object based on the vector or list is created.
}
\examples{
\dontshow{PythonInR:::pyCranConnect()}
if ( pyIsConnected() ) {
pyDictZip(th.string(LETTERS[1:3]), 1:3)
}
}

