.POSIX:
.SUFFIXES:
DIST=dist
TEMPLATES=templ
MD=lowdown
ARTICLES=$(wildcard articles/*.md)
ADEST=$(addprefix $(DIST)/, $(patsubst %.md, %.html, $(ARTICLES)))

.PHONY: blog all articles index
all: index blog articles
blog: $(DIST)/blog.html
articles: ${ADEST}
index: $(DIST)/index.html

$(DIST)/%.html: %.md
	cat $(TEMPLATES)/begin.html > $@
	$(MD) $^ >> $@
	cat $(TEMPLATES)/end.html >> $@
