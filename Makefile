# Variables

filename=modelo-monografia
ERROR_MSG="a problem occurred. please check 'output.log' for more info"

all: $(filename).tex references.bib
	@echo -n "  COMPILING\t"
	@pdflatex -halt-on-error $(filename).tex 2>&1 > output.log || { echo "#1 - "$(ERROR_MSG); exit 1; } 
	@bibtex $(filename) 2>&1 >> output.log || { echo "#2 - "$(ERROR_MSG) && cd .. && exit 1; }
	@makeindex $(filename).nlo -s nomencl.ist -o $(filename).nls 2>> output.log >>output.log || { echo "#3 - "$(ERROR_MSG) && cd .. && exit 1; }
	@pdflatex -halt-on-error $(filename).tex 2>&1 > output.log || { echo "#1 - "$(ERROR_MSG); exit 1; } 
	@pdflatex -halt-on-error $(filename).tex 2>&1 > output.log || { echo "#1 - "$(ERROR_MSG); exit 1; } 
	@echo "OK"

clean:
	@echo -n "  CLEAN\t"
	@rm -f *.aux *.log *.bbl *.blg  *.lof *.lot *.toc *.loa *.lsg *.nlo *.nls *.ilg output.log
	@rm -f $(filename).pdf 
	@echo "OK"
