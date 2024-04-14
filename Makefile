DIST=dist
TEMPLATES=templ
MD=lowdown
MDFLAGS= --html-no-skiphtml --html-no-escapehtml
ARTICLES=$(wildcard articles/*.md)
ADEST=$(addprefix $(DIST)/, $(patsubst %.md, %.html, $(ARTICLES)))

ifndef V
	Q=@
endif

.PHONY: blog all articles index
all: index blog articles
blog: $(DIST)/blog.html
articles: ${ADEST}
index: ${ADEST} $(DIST)/index.html

$(DIST)/%.html: %.md $(TEMPLATES)/begin.html $(TEMPLATES)/end.html
	$(Q)cat $(TEMPLATES)/begin.html > $@
	$(Q)$(MD) $(MDFLAGS) $< >> $@
	$(Q)if [ "$@" = "$(DIST)/index.html" ]; then ./genaindex.sh >> $@; fi
	$(Q)cat $(TEMPLATES)/end.html >> $@
	@printf "$(MD) %-20s %s\n" "$<" "$@"
