---
title: "Why I don't like GNU"
date: 2024-08-17
---
This list does not mention the \[Richard Stallman controversy\]\<Link to Drew DeVault article here\>. 
Nor his squabbles related to [glibc](https://sourceware.org/legacy-ml/libc-hacker/2000-06/msg00233.html)
because:

- Most-everybody knows about it
- These are related to RMS _specificly_, not his broader actions to influence the GNU project.

## 1. The "Linux was developed for the GNU tools" narritive propogated by the FSF is false

From https://www.gnu.org/gnu/linux-and-gnu.html:
>>>its users looked around for other free software to go with it, and found that (for no particular reason) most everything necessary to make a Unix-like system was already available.
What they found was no accident—it was the not-quite-complete GNU system.

In Linus's book *[Just For Fun]*, the GNU project plays little to no role in the creation of Linux.
Linux grew out of comp.os.minix, not anything related to the FSF or GNU project. Additionally, The FSF was
still advocating for Hurd until well after Linux was popular.

From *[The Hurd and Linux (1997)]*:
>>>But we did start the Hurd, back then, and now we have made it work. We hope its superior architecture will make free operating systems more powerful.

The FSF's push for hurd died out sometime in the early 2000's, when Linux was commonplace and Hurd was completely abandoned.

From [A interview with RMS in 99'][RMS tech interview]:
>>> Yes. Unfortunately, progress right now is very slow. We don't have anybody working on it full time, and I wish we did.

## 2. For years, the GNU project was not directly maintaining most of their popular projects

- For several years in the '90s and '00s, GCC, Binutils, GDB, and other FSF projects were being maintained by a external company called [Cygnus].

- The GCC compiler died and forked into EGCS, which then reunited into GCC and is now controlled via committee.

- The de-facto libc on linux for years was a fork of glibc, called [Linux libc] (more commonly refereed to as libc5/libc4).

The FSF, to this day, still does not have direct authoritative control over the GCC compiler.

## 3. The FSF intentionally makes code less modular to spread itself

The reason why GCC didn't become a platform for compiler development like LLVM or qbe is because **the FSF
intentionally kept it back from being so.**

From https://gcc.gnu.org/legacy-ml/gcc/2000-01/msg00572.html:
>>> Anything that makes it easier to use GCC back ends without GCC front
ends--or simply brings GCC a big step closer to a form that would make
such usage easy--would endanger our leverage for causing new front
ends to be free.

**The FSF is a political movement that engages in intentional obfuscation to spread itself.**

## 4. glibc's feature test macros are designed so that people would mark their code with the GNU projects name

[feature_test_macros] are a opt-out, functionality removing, non-portable feature that was largely pioneered
by glibc.

glibc gives you a few test macros by default (which most of the base functions are under).
But If you wanna include something like `strptime()` you need to `#define _XOPEN_SOURCE`
(which is [against POSIX]), except if you do that it **turns the default ones off.**

However, if `#define _GNU_SOURCE`, all feature test macros are implicitly defined.
So *the most convenient way to deal with this opt-out "feature"* is to mark your code with the
GNU projects name.

The `dup3()` system call is neither written by GNU or even in the "GNU Operating System's"
Hurd kernel. And even though this is not GNU you still have to `#define _GNU_SOURCE` to get it.

## 5. GNU code *sucks*

- The `true` command (which is only supposed to return 0) in most other utility implementations is 1 line of
code (i.e. `int main(){}`), GNU true is [80 lines](https://github.com/coreutils/coreutils/blob/master/src/true.c)

(Note: the --help text support is actually a bug and possible security issue, because `/bin/true --help > /dev/full` returns 1 instead of 0)

- GNU cat is [813 lines of code](https://github.com/coreutils/coreutils/blob/master/src/cat.c), Busybox cat is
[217 lines](https://git.busybox.net/busybox/tree/coreutils/cat.c).

- glibc can take up to [3 days (See end of pg. 34)](https://linuxfromscratch.org/lfs/downloads/11.0/LFS-BOOK-11.0.pdf) to build on low-end hardware

- Many GNU libraries such as [glibc](https://stackoverflow.com/questions/57476533/why-is-statically-linking-glibc-discouraged) and [glib](https://bugzilla.gnome.org/show_bug.cgi?id=768215#c16) do not support static linking for no good reason

I could point out more examples, but the message is conveyed that where a programmer might need 10 lines of code to do a job, a GNU programmer would need 100. I have yet to find someone who favors the GNU syntax style. And GNU code is filled with ifdefs, unneeded indirection and complexity, etc (read some yourself, pick a GNU project, any GNU project).

## 6. GNUs obsession with portability adds copius amounts of complexity and helps no one

- The [terminfo/termcap](https://invisible-island.net/ncurses/ncurses.faq.html#which_terminfo) databases
contain support for thousands of different terminals and terminal emulators no one uses (You can try this
out now, set `TERM=vt100` and run some ncurses programs). Terminal escape protocols have been more or less
standardized since ANSI escape codes.

- The `reset` command waits one second to support [physical terminals](https://unix.stackexchange.com/questions/335648/why-does-the-reset-command-include-a-delay) that fell out of favor for emulated ones in the early 90's. It does not contain a check for whether or not the terminal is emulated, and will sleep regardless.

- Portability concerns for "old versions of csh on System V" are [still included in the bash manual](https://www.gnu.org/software/bash/manual/bash.html#Installing-Bash), and the autotools still check for portability concerns from the '80s and '90s

For more examples of this, lets look at the configure scripts for some of the GNU programs.

- The 23,000 line bash configure script contains portability checks for a bash version released in 1997 within [the first 100 lines.](https://github.com/bminor/bash/blob/master/configure#L67C29-L67C38), further down it has checks for a [version of System V released in 1988](https://github.com/bminor/bash/blob/master/configure#L596C29-L596C35), and ["pre-3.0 UWIN ksh"](https://github.com/bminor/bash/blob/master/configure#L22254) which from my searching became outdated in 2002.

-  The 13,000 line gawk configure script (Along with containing about half the portability checks from bash) contains checks for Solaris 7 (released in 1997) [in the first 50 lines](https://github.com/forkmirror/gawk/blob/master/configure), [Someone running a 386/AT Machine apparently had a issue](https://github.com/forkmirror/gawk/blob/master/configure#L39C34-L39C43). Oh no! [IRIX 5.2 (1993) doesn't support -lsocket](https://github.com/forkmirror/gawk/blob/master/configure#L11088). [This entire comment block](https://github.com/forkmirror/gawk/blob/master/configure#L2651) needs no introduction.

This matters in the modern world of software how?

I note that I picked these 2 at random and I'm not searching hard. These are everywhere and I'm sure I could
find many more, No one is building modern versions of bash or the version of gawk from 2021 that Github
mirror provides on System V machines, nor IRIX, Solaris, 386, AIX or even Hurd.

## 7. The FSF fractured the Open Source world for no good reason

Nothing is _wrong_ with the GPLv2, there aren't any loopholes in it. And most of the people I see using it
(including myself for a while) just used it because "The number is bigger therefore it must be even more free than last time" and/or they want compatibility with other GPLv3 code.

If you ask someone to explain the general tenants of the GPLv2 and GPLv3, 90% of the time they come up
with identical answers ("Permitted source code distribution with no non-GPL forks"). Yes there are reasons
why GPLv3 was created such as DRM and Torrenting, but there wasn't large spread exploitation of the GPLv2 to
spread proprietary software in the same way that MINIX became the infrastructure for spyware with the IME.

**However**, The split between the GPLv2 and GPLv3 was infinitely more harmful to the FOSS world than anything it was
conceptually supposed to prevent. The days of codesharing between open-source code without checking the license to make sure it isn't illegal to do so are gone.

A benefit of open source over proprietary software is [code-sharing between projects](https://www.catb.org/~esr/writings/taoup/html/ch16s01.html). And this isn't as effective when there are multiple incompatible open
source licenses that can't legally share code.

## 8. GNU pushes incecently for texinfo, a format no one likes or uses.

GNU info was designed to solve a problem nobody had, and in their push for it they made man pages [worse](https://www.youtube.com/watch?v=rGSZFmQuQrU), which did create a problem, and when people who didn't wanna use GNU info, they created their [own solutions](https://cheat.sh).

It's documentation, not a website. I don't need hyperlinks more than I need the ability to search the whole
thing for a specific phrase. If you really need to split your man page up into multiple blocks there are
so many features, it's more useful to everyone involved to go the [zsh or ffmpeg rout](https://linux.die.net/man/1/zsh).

GNU info is not portable to other operating systems like man pages, nor well used even by most GNU projects,
nor is the browser you need to get a benefit out of its format pleasant to use. Nor is it liked even within the GNU project.
This does not change the fact GNU help2man by default refers to info pages in it's output.

The reason why most man pages don't contain examples is because the GNU project insisted on putting them only in
texinfo pages and not converting them to man pages. And the normalization of this makes man pages worse for
everyone.

[Cygnus]: https://en.wikipedia.org/wiki/Cygnus_Solutions
[Linux libc]: https://www.man7.org/linux/man-pages/man7/libc.7.html
[The Hurd and Linux (1997)]: https://web.archive.org/web/19980126191050/http://www.gnu.org/software/hurd/hurd-and-linux.html
[feature_test_macros]: https://www.man7.org/linux/man-pages/man7/feature_test_macros.7.html
[against POSIX]: https://pubs.opengroup.org/onlinepubs/9799919799/
[Just For Fun]: https://books.google.com/books/about/Just_for_Fun.html?id=Q3aIPwAACAAJ
[RMS tech interview]: https://karmak.org/archive/2003/01/12-14-99.epl.html
