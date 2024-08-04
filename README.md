My website, bare HTML/CSS/MD (No Ruby/Jekyll) and a "Static Site Generator"
written in ~30 lines of Makefile

Look at the makefile to see how it works more extensively, but generally:

- `make all` - builds everything
- `make rss` - builds the rss feed
- `make path/to/file.md` - builds that file

All generated fies are placed in dist/, the rss feed is in dist/articles.xml

You will need `lowdown` to compile the markdown, alternately, you
can change the variable "MD" to specify a markdown compiler.

All makefiles, scripts, sytlesheets, and template pages are licenced under
the 0BSD License, and are free to use, modify, study, and copy for any reason.

All articles in this repository, including the index and blog, are under
CC BY 4.0. Which allows all use and copying provided you give attribution
to the creator.
