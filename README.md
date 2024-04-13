My website, bare HTML/CSS/MD (No Ruby/Jekyll) and a "Static Site Generator"
written in 20 lines of Makefile

Look at the makefile to see how it works more extensively, but generally:

- `make all` - builds everything
- `make blog` - builds the blog
- `make articles` - builds articles
- `make path/to/file.md` - builds that file

There's no "make clean" yet

You will need `lowdown` to compile the markdown, alternately, you
can change the variable "MD" to specify a markdown compiler.

All makefiles, scripts, sytlesheets, and template pages are licenced under
the public domain 0BSD License, and are free to use, modify, study, and
copy for any reason.

All articles in this repository, including the index and blog, are under
CC BY 4.0. Which allows all use and copying provided you give attribution
to the creator.
