MAIN := supplement
PDFLATEX := pdflatex -interaction=nonstopmode
BIBTEX := bibtex

.PHONY: all clean zip

all: $(MAIN).pdf

zip: $(MAIN).zip

$(MAIN).zip: $(MAIN).pdf etna2018.inp garachico2025.inp
	python3 -m zipfile -c $@ $^

$(MAIN).pdf: $(MAIN).tex ../references.bib copernicus.cls copernicus.cfg copernicus.bst
	$(PDFLATEX) $(MAIN)
	$(BIBTEX) $(MAIN)
	$(PDFLATEX) $(MAIN)
	$(PDFLATEX) $(MAIN)

clean:
	rm -f $(MAIN).aux $(MAIN).bbl $(MAIN).blg $(MAIN).log \
	      $(MAIN).out $(MAIN).toc $(MAIN).pdf $(MAIN).zip
