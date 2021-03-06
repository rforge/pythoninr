% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PySource.R
\name{pySource}
\alias{pySource}
\title{Reads mixed R and Python code from a file}
\usage{
pySource(file, local = FALSE, echo = verbose, print.eval = echo,
  verbose = getOption("verbose"), prompt.echo = getOption("prompt"),
  max.deparse.length = 150, chdir = FALSE,
  encoding = getOption("encoding"), continue.echo = getOption("continue"),
  skip.echo = 0, keep.source = getOption("keep.source"))
}
\arguments{
\item{file}{a character string giving the pathname of the file.}

\item{local}{see documentation of source}

\item{echo}{see documentation of source}

\item{print.eval}{see documentation of source}

\item{verbose}{see documentation of source}

\item{prompt.echo}{see documentation of source}

\item{max.deparse.length}{see documentation of source}

\item{chdir}{see documentation of source}

\item{encoding}{see documentation of source}

\item{continue.echo}{see documentation of source}

\item{skip.echo}{see documentation of source}

\item{keep.source}{see documentation of source}
}
\description{
The function BEGIN.Python allows interactive development
             but doesn't work in combination with the function source.
             Therefore pySource provides an alternative to the function source
             which also can handle BEGIN.Python statements.
}
\details{
The function pySource works similar to source, but code 
         which is enclosed between BEGIN.Python and END.Python is
         replaced by pyExec and the quoted version of the code.
}
\examples{
\dontrun{
writeLines(c("x <- 3", "BEGIN.Python()", 
             "x=3**3", "print(3*u'Hello R!\\\\n')", 
             "END.Python"), "myMixedCode.R")
pySource("myMixedCode.R")
}
}

