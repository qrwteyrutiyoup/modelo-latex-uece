# Variables

filename=modelo-monografia
TMP_DIR=./tmp
ERROR_MSG="a problem occurred. please check 'output.log' for more info"

all: $(filename).tex references.bib
	@echo -n "  COMPILING\t"
	@rm -rf $(TMP_DIR)
	@mkdir -p $(TMP_DIR)/chapters
	@pdflatex -output-directory=$(TMP_DIR) -halt-on-error $(filename).tex 2>&1 > output.log || { echo "#1 - "$(ERROR_MSG); exit 1; } 
	@cd $(TMP_DIR) && ln -s ../references.bib && bibtex $(filename) 2>&1 >> output.log || { echo "#2 - "$(ERROR_MSG) && cd .. && exit 1; }
	@pdflatex -output-directory=$(TMP_DIR) $(filename).tex 2>&1 >> output.log || { echo "#3 - "$(ERROR_MSG); exit 1; }
	@# Gambiarra, removendo alguns itens do sumario
	@cat $(TMP_DIR)/$(filename).toc | \
		grep -v -E '{Resumo|Abstract|Lista de Figuras|Lista de Tabelas|Lista de Siglas|Lista de S.*mbolos|Lista de Algoritmos}' \
		> $(TMP_DIR)/$(filename).toc.2
	@mv -f $(TMP_DIR)/$(filename).toc.2 $(TMP_DIR)/$(filename).toc
	@# now removing appendixes sections from summary
	@cat $(TMP_DIR)/$(filename).toc | grep -v -E '\\contentsline {section}{\\numberline {[A-Z]\.[0-9]+}' > $(TMP_DIR)/$(filename).toc.2
	@mv -f $(TMP_DIR)/$(filename).toc.2 $(TMP_DIR)/$(filename).toc
	@cat $(TMP_DIR)/$(filename).toc | sed -e 's/{chapter}{Ap\\^endice{} /{chapter}{\\hbox to\\@tempdima {\\hfil }Ap\\^endice{} /' > $(TMP_DIR)/$(filename).toc.2
	@mv -f $(TMP_DIR)/$(filename).toc.2 $(TMP_DIR)/$(filename).toc
	@#Gambiarra, ordenando as entradas da lista de siglas
	@./modelo/bin/sort-acronyms.pl $(TMP_DIR)/$(filename).lsg
	@pdflatex -output-directory=$(TMP_DIR) $(filename).tex 2>&1 >> output.log || { echo $(ERROR_MSG); exit 1; }
	@mv -f $(TMP_DIR)/$(filename).pdf .
	@rm -rf $(TMP_DIR)
	@echo "OK"

clean:
	@echo -n "  CLEAN\t"
	@rm -f *.aux *.log *.bbl *.blg  *.lof *.lot *.toc *.loa *.lsg output.log
	@rm -rf $(TMP_DIR)
	@rm -f $(filename).pdf
	@echo "OK"
