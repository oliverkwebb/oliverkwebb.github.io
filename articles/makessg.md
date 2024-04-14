<title>A basic guide on make, and how to make a static site generator using it</title>
## A basic guide on `make`, and how to make a static site generator using it

When making my website, generating static webpages for
my blogs and articles was a big concern. I want to be able
to manipulate templates and sytlesheets easily and have that
translate to my articles and content. HTML, to put it simply,
sucks for this type of work.

The solution is static site generation, which is analogous to ahead of time compilation. 
There are a variety of tools that can be used for this. [Jekyll](https://jekyllrb.com/)
is the one GitHub endorses, the problem I have with that is that it is
written in Ruby, which means that I'd have to pull in megabytes of extra
dependencies and slow the building process down for something that ultimately
takes away control from me.

What I need is something that is efficient, customizable, and fast. And above all,
simplistic. This is where `make` comes into the picture.

In case you don't already know what `make` does or how it works; `make`
takes a "makefile" with a list of rules. Each rule has a list of commands
to run. And you can do `make rule` to run the commands in that rule. If you
specify a list of rules, it will run all those rules, if you specify no rules,
it will run the first rule specified in the makefile (commonly, this rule is
called "all")

```
$ cat Makefile
foo:
    echo bar
baz:
    echo foo
$ make foo baz
echo bar
bar
echo foo
foo
```

Make will list the commands it runs as it runs them, and will abort if
a command returns non-zero. Printing the command it runs can be disabled
by placing `@` at the start of the command. And aborting on failure of a
command can be disabled by placing `-` at the start of the command

Additionally, you can refer to variables in your makefile, and assign them
on the command line or in your makefile.

```
$ cat Makefile
BAZ=123
foo:
    @echo $(BAR) $(BAZ)
baz:
    -false
$ make baz foo BAR=abc
abc 123
```

This allows for macros and the quick running of commands without manually typing
in the build commands. But this is not where the true magic of make is.

A rule is not just a name for a macro that you type in on the command line,
it is a pattern. And more importantly, it is a filename unless said otherwise.
You can also specify prerequisites for running a rule. So you can say `a: b c`,
which means that rule b and c have to run before a. You can specify that a
rule is not a filename by putting a line that says `.PHONY: [rule1] [rule2]`.
This means that `rule1` and `rule2` will always run when called.

Finally, if a rule is

1. A file, which exists
3. All the prerequisite rules are files
4. All prerequisite files "last changed" date are older than the main file's

The rule is considered completed, and any commands from it are not ran.

This makes ahead of time compilation with object files much faster. Since you can
change one file, and it will detect that all the other "object files" are newer
then their respective source files *except* the one you have changed. And it
will automatically build only that changed file. This reduces the build time.

But having a rule for each source file seems excessive, right? This is where
patterns come into play. The character `%` means "anything" and is analogous to
`*` in shell globbing, this allows us to create a rule for all `.c` files

But how will we refer to the source file in the build command? This is where
special variables come into play. You can use `$<` to refer to your first item in
the list of prerequisites, and `$@` to refer to your rule name. Note this is
not the pattern that the specified rule matched, it is the rule that matched
the pattern.

```
%.o: %.c
    $(CC) $(CFLAGS) $< -o $@
```

If you run `make main.o`, it will detect that "main.o" matches the pattern 
rule "%.o", next it will check if the file "main.c" is there. If it is not and
there is no rule that matches "main.c", it will not know what to do and fail.
Otherwise, if the file "main.c" is older than the file "main.o", it will assume
no changes have been made and there is therefore nothing to be done. Then, it
will run the build command, refereeing to the variable CC (By default "c99"),
passing in the flags CFLAGS, and running this on the prerequisite files name
"main.c" outputting to our rule name, the file "main.o".

This is the essence of `make`'s functionality, and most of the useful stuff POSIX
specifies. But there are other things in GNU make, like the ability to add a
prefix to all items in a list with the addprefix function, or the wildcard
function to get all items and put them in a list. Functions are specified in
variable definitions and arguments are separated by commas. So that evaluating
`$(addprefix 123, a b c)` will return "123a 123b 123c".

We can use this knowledge already to do some pretty cool things, but with our
newly gained skills lets use this to make a static site generator. Since
the problem of turning markdown files into html files is similar to the
problem of turning source files into object files, we can create a
simple rule that does 99% of our work.

```
%.html: %.md
    $(MARKDOWN) $(MDFLAGS) $< >> $@
```

But markdown compilers don't usally generate HTML boilerplate, and we might
want to import a stylesheet, and maybe save to a "dist" directory. So that
if we have a "index.md" file, it will compile to `$(DIST)/index.html`, this
is no issue for us.

```
$(DIST)/%.html: %.md
    cat $(TEMPLATES)/begin.html > $@
    $(MARKDOWN) $(MDFLAGS) $< >> $@
    cat $(TEMPLATES)/end.html >> $@
```

Notice how % goes after the `$(DIST)` prefix, which means that referencing
it in our prerequisite list will not add it as a prefix.

We have our workhorse rule, but, "how do we put this together?",
we can specify variables for our markdown compiler (in this example, I used
`lowdown`), and scan for files in a source directory using
the wildcard command. Making them valid rule names by substituting .md prefixes
with .html ones, and adding the prefix `$(DIST)`

```
DIST=dist
TEMPLATES=templ
MARKDOWN=lowdown

PAGES=$(wildcard pages/*.md)
PDEST=$(addprefix $(DIST)/, $(patsubst %.md, %.html, $(PAGES)))

# ${VAR} breaks down VAR into a list of rules
all: ${PDEST}

$(DIST)/%.html: pages/%.md
    cat $(TEMPLATES)/begin.html > $@
    $(MARKDOWN) $(MDFLAGS) $< >> $@
    cat $(TEMPLATES)/end.html >> $@
```

If you want to add a conditional generation step for the index, you
can put a `if [ $@ = $(DIST)/index.html ]; then ./gen >> $@; fi` rule in
your main rule. You can add almost infinite customization to this with
conditionals or extra rules.

If you want more info on this, I'd suggest you look at the
[GNU make manual](https://www.gnu.org/software/make/manual/make.pdf),
and [my Makefile](https://github.com/oliverkwebb/oliverkwebb.github.io/blob/main/Makefile)
that actually does this and is building the page you are reading right now.
