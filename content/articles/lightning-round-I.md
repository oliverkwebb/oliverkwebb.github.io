---
title: "Lightning Round of Miscellaneous Linux Information"
date: 2025-04-28T14:02:46-05:00
draft: true
---

1. The `reset` waits 1 second for physical terminal hardware to move, on all modern terminals the delay can be removed by using `tput reset`.
2. On glibc, `ldd` is a shell script that sets the environment variable `LD_TRACE_LOADED_OBJECTS` before running the command. Which means you can replicate the behavior of `ldd` by doing `LD_TRACE_LOADED_OBJECTS=1 [command]`.
3. ncurses relies on the terminfo database for portability, which supports physical terminals all the way back to the VT-100.
You can make ncurses programs print VT-100 escape codes by doing `TERM=vt100 [command]` (`vim`, `clear`, `reset`, etc).
4. The split between `/{bin,lib}` and `/usr/{bin,lib}` was a workaround around disk space constraints in the 1970's, originally, `/usr/` stored user accounts (as per the name). But that was later moved to `/home/` to store accounts on a different drive, which let `/usr/` store operating-system related files.
5. The creation of the IOCCC was largely inspired by the original code for the Bounre Shell, the precursor for the design of most modern linux shells. The code for the original Bounre Shell had been mangled to look like ALGOL.
6. Additionally, the Bounre Shells syntax is... like that, because its design was heavily inspired by ALGOL.
