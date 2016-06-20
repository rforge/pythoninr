file = PythonInR

all: Sweave latex copy clean

latex: ${file}.tex PythonInR.bib
	pdflatex ${file}.tex
	bibtex ${file}
	bibtex ${file}
	pdflatex ${file}.tex
	pdflatex ${file}.tex

Sweave:
	R -e 'library(highlight); Sweave( "${file}.Rnw", driver= HighlightWeaveLatex() )'

copy:
	cp PythonInR.pdf ../PythonInR.pdf

clean:
	rm -f *~
	rm -f .Rhistory
	rm -f $(file).aux $(file).log $(file).bbl $(file).blg $(file).out
	rm -f Rplots.ps code.tex $(file)-*
	rm -r *.xlsx

