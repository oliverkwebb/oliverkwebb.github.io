---
title: "The C Model: Symbols and Macros"
date: 2025-04-28T22:07:12-05:00
draft: true
---
C is an extremely hands off language in what it allows you to do, and its model and syntax allow
for a lot of "weird" or unconventional practice. One of the more common examples of this is [Duff's Device](https://en.wikipedia.org/wiki/Duff%27s_device), which shows that a switch statement is syntactically
the same as a mult-destination goto:

```c
send(short to, short from, int count)
{
    register n = (count + 7) / 8;
    switch (count % 8) {
    case 0: do { *to = *from++;
    case 7:      *to = *from++;
    case 6:      *to = *from++;
    case 5:      *to = *from++;
    case 4:      *to = *from++;
    case 3:      *to = *from++;
    case 2:      *to = *from++;
    case 1:      *to = *from++;
            } while (--n > 0);
    }
}
```

This flexibility allows for you to

# C is not a portable assembly
More often than not in an argument for C, I see the phrase "portable assembly" get thrown around.
And whilst C maps nicely to a subset of most assembly languages[^1]. And the way C was originally
designed was probably a nice abstraction over PDP-11 assembly. The similarities end there, assembly
allows to do to the fine tuned control that C simply can't do. C is more akin to a higher level
version of [brainfuck](https://en.wikipedia.org/wiki/Brainfuck).

[^1]: [Except when it doesn't](https://gcc.gnu.org/onlinedocs/gccint/Libgcc.html)
