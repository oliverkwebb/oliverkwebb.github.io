DIST=dist
TEMPLATES=templ
MD=lowdown
MDFLAGS= --html-no-skiphtml --html-no-escapehtml --html-no-owasp --out-no-smarty
ARTICLES=$(wildcard articles/*.md)
ADEST=$(addprefix $(DIST)/, $(patsubst %.md, %.html, $(ARTICLES)))

export MD MDFLAGS DIST TEMPLATES

ifndef V
	Q=@
endif

.PHONY: blog all articles index rss
all: index blog articles rss
blog: $(DIST)/blog.html
articles: ${ADEST}
index: articles $(DIST)/index.html
rss: $(DIST)/articles.xml

$(DIST)/%.html: %.md $(TEMPLATES)/begin.html $(TEMPLATES)/end.html
	$(Q)cat $(TEMPLATES)/begin.html > $@
	$(Q)$(MD) $(MDFLAGS) $< >> $@
	$(Q)if [ "$@" = "$(DIST)/index.html" ]; then ./genaindex.sh list >> $@; fi
	$(Q)cat $(TEMPLATES)/end.html >> $@
	@printf "$(MD) %-20s %s\n" "$<" "$@"

$(DIST)/articles.xml: ${ADEST}
	./genaindex.sh rss > $@
