---
title: The standard GNU history myth
date: 2024-08-04
draft: true
---
All too often, I see people espouse a heavily warped view of Linux history which
gives a too-large amount of credit to the FSF for the development and takeoff of
Linux. This view of history is the most available, most widely spread, and most
believed.

This version of history hides the work of BSD, MIT, and Minix developers.
Attributing decades of work by thousands of people to a single organization.
This is not to say that the FSF did nothing, Utilities like the GCC compiler,
glibc, the coreutils, etc. were certainly useful to the linux community. But
in a world where these didn't exist; Minix or BSD utilities would've almost
certainly taken their place.

## Myth: "The GNU project invented/poinerred free software"

Before the creation of the FSF, Source code being available to the users of
software was commonplace. Version 6 AT&T UNIX's source code was being spread
for years by the [Lions Book]. BSD's code was both open and free to distribute,
leading to a lawsuit between AT&T and BSD.

The [public domain TeX] typesetting system predates the FSF by half a decade.
The creation of the [MIT License] was almost certainly independent from the FSF.
[The original vi] and near-any application that has its roots in BSD was open
source. The C, Korn, and Bourne Shell's (Which all predate the FSF) were under
permissive licensing.

These are _some_ examples of "open source" software before the FSF. In reality,
the FSF did not even popularize the idea of source code being free to distribute.

## Myth: "The creation of Linux relied on the GNU project"

The GNU project did not contribute development effort to the Linux kernel until
well after it took off. That would be the Minix community, which the early
development of linux happened in. Even as Linux 1.0 and the rise of the internet
happened, the GNU project was focused on the Hurd kernel.

**The FSF was still advising people to use Hurd until the late '90s**\
From "[The Hurd and Linux (1997)]":
>>>But we did start the Hurd, back then, and now we have made it work. We hope its superior architecture will make free operating systems more powerful.

### What _did_ the FSF contribute

The two irreplaceable contributions by the FSF to Linux were the GCC compiler and the
GPL. While these were certainly useful in the creation and development of Linux.
For example, In a world without GCC, BSD's [PCC compiler] or the Minix C compiler
would've taken it's place.

**"Then why did GCC outpace other compilers?"**:\
Sun developers flocked to GCC
(A compiler which already supported SunOS) after Sun removed the compiler from
the base set of utilities and started charging for it.
([See the "gcc" section of this article][1])

### The FSF was barely holding on to these projects
For several years in the '90s and '00s, GCC, Binutils, GDB, and other
FSF projects were being maintained by a external company called [Cygnus].
The GCC compiler died and forked into [EGCS], which then reunited into GCC
and is now controlled via committee. And the de-facto libc on linux for
years was a fork of glibc, called [Linux libc]
(more commonly refereed to as libc5/libc4).

These forks can be attributed to existing GNU software often being unmaintained and
incomplete. The FSF is a movement that prioritizes philosophy over cleanliness of code

**The FSF intentionally makes code less modular to spread itself**\
From https://gcc.gnu.org/legacy-ml/gcc/2000-01/msg00572.html:
>>> Anything that makes it easier to use GCC back ends without GCC front
ends--or simply brings GCC a big step closer to a form that would make
such usage easy--would endanger our leverage for causing new front
ends to be free.

[Cygnus]: https://en.wikipedia.org/wiki/Cygnus_Solutions
[Linux libc]: https://www.man7.org/linux/man-pages/man7/libc.7.html
[Lions Book]: https://archive.org/details/CommentarySixthEditionUNIX
[MIT License]: https://opensource.com/article/19/4/history-mit-license
[The original vi]: https://en.wikipedia.org/wiki/Vi_(text_editor)
[public domain TeX]: https://en.wikipedia.org/wiki/TeX#License
[PCC compiler]: https://en.wikipedia.org/wiki/Portable_C_Compiler
[1]: http://www.groklaw.net/article.php?story=20050525231654621
[The Hurd and Linux (1997)]: https://web.archive.org/web/19980126191050/http://www.gnu.org/software/hurd/hurd-and-linux.html
[EGCS]: https://en.wikipedia.org/wiki/GNU_Compiler_Collection#EGCS_fork
[2]: https://www.datacenterknowledge.com/business/linus-torvalds-on-early-linux-history-gpl-license-and-money
