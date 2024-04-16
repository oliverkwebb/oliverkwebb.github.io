#!/usr/bin/make -f

# Website and SSG specific stuff, defines:
# DIST, TEMPLATES, MD, MDFLAGS, WEBSNAME, and WEBSURL
include config.mk

export MD MDFLAGS DIST TEMPLATES WEBSNAME WEBSURL 
Q=@

ADEST=$(addprefix $(DIST)/, $(patsubst %.md, %.html, $(wildcard articles/*.md)))
PAGES=$(filter-out $(DIST)/%, $(wildcard *.md))

all: $(addprefix $(DIST)/, $(patsubst %.md, %.html, $(PAGES))) rss
articles: ${ADEST}
rss: $(DIST)/articles.xml
clean:
	rm -rf dist/*

.PHONY: all articles rss clean

$(DIST)/%.html: %.md $(TEMPLATES)/begin.html $(TEMPLATES)/end.html
	$(Q)mkdir -p $(@D)
	$(Q)cat $(TEMPLATES)/begin.html > $@
	$(Q)$(MD) $(MDFLAGS) $< >> $@
	$(Q)if [ "$@" = "$(DIST)/index.html" ]; then ./genindex htmllist >> $@; fi
	$(Q)cat $(TEMPLATES)/end.html >> $@
	@echo $<

$(DIST)/articles.xml: ${ADEST}
	./genindex rssfeed > $@
