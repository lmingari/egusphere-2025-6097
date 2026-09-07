# --- Configuration Variables ---
# The name of your main LaTeX file (without the .tex extension)
MAIN_FILE := main

# Directory containing the split section files
SECTION_DIR := sections

# List of section files (without .tex extension) — order not critical here,
# since main.tex controls the actual \include order
SECTIONS := introduction vae assimilation experiments results conclusions

# Full paths to section .tex files, used as prerequisites
SECTION_FILES := $(addprefix $(SECTION_DIR)/,$(addsuffix .tex,$(SECTIONS)))

# Name of the flattened, single-file output (for submission/archiving)
MERGED_FILE := $(MAIN_FILE)_merged

# Compiler commands
PDFLATEX := pdflatex -interaction=nonstopmode
BIBTEX := bibtex
LATEXPAND := latexpand

# --- Targets ---

.PHONY: all clean view merge

# Default target: builds the PDF
all: $(MAIN_FILE).pdf

# Target to generate the PDF file using BibTeX
$(MAIN_FILE).pdf: $(MAIN_FILE).tex $(SECTION_FILES)
	# Step 1: First pdflatex run to generate the .aux file
	$(PDFLATEX) $(MAIN_FILE)

	# Step 2: Run bibtex. This reads the .aux file and creates the .bbl file.
	# The argument to bibtex is the name of the .aux file WITHOUT the extension.
	$(BIBTEX) $(MAIN_FILE)

	# Step 3: Second pdflatex run to incorporate the .bbl file and resolve citations
	$(PDFLATEX) $(MAIN_FILE)

	# Step 4: Final pdflatex run to resolve all cross-references (TOC, page numbers, etc.)
	$(PDFLATEX) $(MAIN_FILE)

# Target to flatten the split document into a single .tex file
# Useful for journal submission or archiving.
merge: $(MAIN_FILE).tex $(SECTION_FILES)
	$(LATEXPAND) $(MAIN_FILE).tex > $(MERGED_FILE).tex
	@echo "Flattened file written to $(MERGED_FILE).tex"

# Target to open the generated PDF
view: $(MAIN_FILE).pdf
	zathura $(MAIN_FILE).pdf &

# Target to remove all generated temporary files
clean:
	rm -f $(MAIN_FILE).aux $(MAIN_FILE).log $(MAIN_FILE).out \
	      $(MAIN_FILE).toc $(MAIN_FILE).blg $(MAIN_FILE).bbl \
	      $(MAIN_FILE).lof $(MAIN_FILE).lot $(MAIN_FILE).fls \
	      $(MAIN_FILE).synctex.gz $(MAIN_FILE).pdf \
		  $(MERGED_FILE).tex \
		  $(addprefix $(SECTION_DIR)/,$(addsuffix .aux,$(SECTIONS)))

