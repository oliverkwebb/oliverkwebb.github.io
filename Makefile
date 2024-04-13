.POSIX:
.SUFFIXES:
DIST=dist
TEMPLATES=templ
MD=lowdown
ARTICLES=$(wildcard articles/*.md)
ADEST=$(addprefix $(DIST)/, $(patsubst %.md, %.html, $(ARTICLES)))

ifndef V
	Q=@
	P=@true
endif

.PHONY: blog all articles index
all: index blog articles
blog: $(DIST)/blog.html
articles: ${ADEST}
index: $(DIST)/index.html

$(DIST)/%.html: %.md $(TEMPLATES)/begin.html $(TEMPLATES)/end.html
	$(Q)cat $(TEMPLATES)/begin.html > $@
	$(Q)$(MD) $< >> $@
	$(Q)cat $(TEMPLATES)/end.html >> $@
	@printf "$(MD) %-20s %s\n" "$<" "$@"
