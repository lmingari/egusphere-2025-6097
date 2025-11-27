# --- Configuration Variables ---
# The name of your main LaTeX file (without the .tex extension)
MAIN_FILE := main

# Compiler commands
PDFLATEX := pdflatex -interaction=nonstopmode
BIBTEX := bibtex

# --- Targets ---

.PHONY: all clean view

# Default target: builds the PDF
all: $(MAIN_FILE).pdf

# Target to generate the PDF file using BibTeX
$(MAIN_FILE).pdf: $(MAIN_FILE).tex
	# Step 1: First pdflatex run to generate the .aux file
	$(PDFLATEX) $(MAIN_FILE)

	# Step 2: Run bibtex. This reads the .aux file and creates the .bbl file.
	# The argument to bibtex is the name of the .aux file WITHOUT the extension.
	$(BIBTEX) $(MAIN_FILE)

	# Step 3: Second pdflatex run to incorporate the .bbl file and resolve citations
	$(PDFLATEX) $(MAIN_FILE)

	# Step 4: Final pdflatex run to resolve all cross-references (TOC, page numbers, etc.)
	$(PDFLATEX) $(MAIN_FILE)

# Target to open the generated PDF
view: $(MAIN_FILE).pdf
	# Replace 'xdg-open' with your preferred PDF viewer (e.g., 'open' on macOS, 'evince' or 'zathura' on Linux, or 'start' on Windows)
	zathura $(MAIN_FILE).pdf

# Target to remove all generated temporary files
clean:
	rm -f $(MAIN_FILE).aux $(MAIN_FILE).log $(MAIN_FILE).out \
	      $(MAIN_FILE).toc $(MAIN_FILE).blg $(MAIN_FILE).bbl \
	      $(MAIN_FILE).lof $(MAIN_FILE).lot $(MAIN_FILE).fls \
	      $(MAIN_FILE).synctex.gz $(MAIN_FILE).pdf

