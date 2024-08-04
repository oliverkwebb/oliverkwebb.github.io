---
Title: Writing a UTF-8 safe AWK
Date: 2024-04-26
---
One of the things the toybox project prioritizes is unicode handling for it's
applications. This has kept things like [the fully GNU compatible tr](http://lists.landley.net/pipermail/toybox-landley.net/2023-October/029845.html)
from being promoted from the pending/ directory for years because they
wish to break compatibility by making tr unicode safe. Toybox's plans for awk
are [no different story](http://lists.landley.net/pipermail/toybox-landley.net/2021-June/012453.html).

Fortunately for any [awk implementation](https://www.github.com/raygard/wak)
attempting to get into toybox; Awk works with strings, while tr works with
characters. Awk does not regularly index into the strings it works with, and
when it does it only happens in a few functions. This means that if we want
to handle UTF-8, we can divide and conquer.

### What a UTF-8 Safe awk needs

The [gawk(1) man page](https://man7.org/linux/man-pages/man1/gawk.1.html) says
these 4 functions work on "characters, not bytes":

- substr()
- length()
- match()
- index()

The second addition awk book also mentions these:

- printf %c [STRING]
- printf %c [CODEPOINT]
- \u[CODEPOINT]

And finally, these work internally by indexing the string:

- toupper()
- tolower()

That's "divide" out of the way, now lets conquer.

### Implementing a UTF-8 Awk

A reminder that we are trying to add in UTF-8 support to a existing awk, not
make a new one with UTF-8 support.

In a awk that is UTF-8 safe, all strings are indexed by a number of UTF-8
characters. While in C, all strings are indexed based off of bytes. This
means that for substr(), length(), match(), and index(). We need a way to
convert between the two. This can be done by two functions, one which counts
the bytes in a utf8 string, and another that counts the characters in a C byte
string. This work was [originally done by me](https://github.com/raygard/wak/commit/2e94cd3de8fb4d091ca19bb429cb4b2cb9d6a80e)
with 2 functions that acted as analogs to `mbrtowc()` and `wcstombs()` from libc.
And [Ray Gardner de-over-engineered](https://github.com/raygard/wak/commit/2e94cd3de8fb4d091ca19bb429cb4b2cb9d6a80e) these functions.

As long as you have the ability to turn unicode codepoints back into strings,
\u[CODEPOINT] is a easy fix too. While the current digit you are reading is a
valid hexidecimal character, read that digit into a buffer. Then `strtol()` to
turn that buffer into a codepoint, then convert that codepoint back into a string.
There are printf format escapes that print 1 utf8 character of a string.
Which in practice makes printf %c easier. The tolower() and toupper()
problem is more complex, but fundamentally involves taking a string, running
though it and running `towlower/upper()` on it, expanding it when needed.
You can look at [the actual code which does this](https://github.com/raygard/wak/commit/2e94cd3de8fb4d091ca19bb429cb4b2cb9d6a80e),
as that will explain it better than I could.

FS/split() say that if the field separator is more than one character, it will be
treated as a regex. This in practice does not matter, since a multi-byte unicode
FS will never contain any special regexp syntax character.

Writing in UTF-8 support into a already existing awk is a lot simpler than it seems.
wak needed less than 100 lines to make itself UTF-8 safe. Most of the hard part
is figuring out _what_ needs unicode handling.
