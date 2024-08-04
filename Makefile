#!/usr/bin/make -f

# Website and SSG specific stuff, defines:
include config.mk
export MD MDFLAGS DIST TEMPLATES WEBSNAME WEBSURL

ADEST=$(addprefix $(DIST)/, $(patsubst %.md, %.html, $(wildcard articles/*.md)))
PAGES=$(filter-out $(DIST)/%, $(wildcard *.md))
Q=@

all: $(addprefix $(DIST)/, $(patsubst %.md, %.html, $(PAGES))) rss
articles: ${ADEST}
rss: $(DIST)/articles.xml

.PHONY: all articles rss help

$(DIST)/%.html: %.md $(TEMPLATES)/begin.html $(TEMPLATES)/end.html
	@echo $<
	$(Q)mkdir -p $(@D)
	$(Q)cat $(TEMPLATES)/begin.html > $@
	$(Q)if [ $(@D) = "$(DIST)/articles" ]; then ./articleheader $< >> $@; fi
	$(Q)$(MD) $(MDFLAGS) $< >> $@
	$(Q)if [ "$@" = "$(DIST)/index.html" ]; then ./genindex htmllist >> $@; fi
	$(Q)cat $(TEMPLATES)/end.html >> $@

$(DIST)/articles.xml: ${ADEST}
	./genindex rssfeed > $@
