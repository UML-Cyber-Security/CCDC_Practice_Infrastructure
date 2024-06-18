#
# Makefile
# chris, 2020-01-31 17:07

MD_FILES = $(shell find . -name '*.md')
PDF_FILES = $(patsubst ./%.md, printable/%.pdf, $(MD_FILES))

.PHONY: all
all: $(PDF_FILES)

printable/%.pdf: %.md
	@mkdir -p "$(@D)"
	@echo converting "$<" to "$@"
	@pandoc $< --wrap=auto -o $@


.PHONY: clean
clean: 
	rm -r printable
# vim:ft=make
#
