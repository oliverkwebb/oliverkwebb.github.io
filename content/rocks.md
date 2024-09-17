---
date: 2024-09-14T11:13:15-05:00
---
# Software I Use and Recommend

### Distros

* [Arch Linux] - Modern, minimal, a good package manager, well supported, and ran by hobbyists.
* [Artix Linux](https://artixlinux.org/) - Arch without SystemD.
* [Alpine Linux](https://www.alpinelinux.org/) - As small and simplistic as it gets.

### Base Software

* [busybox](https://www.busybox.net) - The Swiss Army Knife of Embedded Linux.
* [toybox](https://landley.net/toybox/) - A rewrite of busybox with a focus on clean code.
* [mksh](https://github.com/MirBSD/mksh) - Small portable version of the Korn Shell.

### Libraries

* [musl](https://musl.libc.org) - A minimal standard C library implementation that's much more flexible than glibc.
* [netbsd-curses][ncurses implementations] - A implementation of ncurses that's much smaller and less bloated.

### Other Command Line Software

* [vis](https://github.com/martanne/vis) - Minimal yet extensible vi clone based on structural regex's.
* [tmux](https://github.com/tmux/tmux) - Terminal Multiplexer, provides tabbing and session management inside the terminal.
* [pv](https://www.ivarch.com/programs/pv.shtml) - Pipe viewer, view the data output of a pipe.
* [hugo](https://www.gohugo.io) - Extensible static site generator based on templates.
* [groff](https://www.gnu.org/software/groff/manual/groff.html) - A implementation of troff macros for making papers and such without LaTeX (or even worse; LibreOffice).
* [graphviz](https://graphviz.org/) - A simple graphing software that can be used for making UML diagrams, dependency chain maps, etc.]
* [sc-im](https://github.com/andmarti1424/sc-im) - A simple spreadsheet and CSV editor.
* [pass](https://www.passwordstore.org/) - A simple password manager written in bash.
* [iamb](https://iamb.chat/) - Vim Like matrix client with sixel image support.

### Xorg Programs

* [xwallpaper](https://github.com/stoeckmann/xwallpaper) - Simple wallpaper setter.
* [dwm](https://dwm.suckless.org) - Dynamic Widow Manager.
* [i3wm](https://i3wm.org/) - Small window manager with different layouts and customization ability.
* [nsxiv](https://codeberg.org/nsxiv/nsxiv/) - Image viewer with gifs, scripting, and grid mode support.
* [st](https://st.suckless.org) - Simple terminal, does its job with as small a footprint as possible.
* [dmenu](https://tools.suckless.org/dmenu/) - General purpose select menu.
* [i3blocks](https://vivien.github.io/i3blocks/) - Shell script based bar generator for i3wm's bar.

### Wayland Programs

* [sway](https://swaywm.org/) - A fork of i3wm for wayland, integrates tasks that xrandr and xwallpaper would normally do into the window manager.
* [foot](https://codeberg.org/dnkl/foot/) - Foo Terminal, Minimal Wayland Terminal.
* [swiv](https://github.com/ShaqeelAhmad/swiv) - A fork of SXIV for wayland.
* [Waybar](https://github.com/Alexays/Waybar) - A highly extensible wayland bar.

### General Purpose GUI Programs

* [dunst](https://github.com/dunst-project/dunst) - Minimal notification manager and daemon.
* [drawing](https://maoschanz.github.io/drawing/) - Image editor with a simple UI, the MS paint of Linux.
* [mpv](https://mpv.io/) - Minimal extensible media player.
* [zathura](https://pwmt.org/projects/zathura/) - Vim-like document reader for PDF and other formats.

### Why systemd sucks

SystemD is actively harmful to the world of open source. An init system's only job is to
get out of someones way and to start up some background daemons. Before SystemD, no one *had to care*
if a machine was running OpenRC, runit, sinit, or SysVinit. Those systems recognized their **one and only**
job was to boot the system into a usable environment and handle shutdown cleanup, reap orphan processes, and
start, stop, and track the dependency chain of daemons (whilst ideally taking advantage of SMP).

SystemD however, besides being a order of magnitude larger than other init systems, tries to invade userspace
constantly by embracing and extending userspace-level APIs. A recent case study on this is their [sudo replacement],
run0, which exists because sudo is 250,000 lines of code, and instead of using the fairly simple and easy to understand
API that is setuid. They rely on the systemd exclusive API (configured with **javascript**) polkit. Also see dbus, udev,
and [trying to shove systemd into other applications][tmuxissue].

Microsoft made office open XML so complex because Microsoft [doesn't want you to have a choice][OOXML], and now
they're dumping money into SystemD because SystemD [doesn't want you to have a choice][SystemD-RedHat].
GCC mangled their project structure because the FSF [doesn't want you to have a choice][RMSEML].

There's a widely accepted name for this. "Vendor lock-in"

Lets contrast this with other linux software. There are multiple implementations of the UNIX utilities in wide use,
and I'm able to swap out them for each other to my hearts desire if I don't like the fact GNU `true` can return 1
(`/bin/true --help > /dev/full`) or busybox dd doesn't do `status=progress`. If I don't like the fact glibc produces
massive static binaries due to no [-ffunction-sections] I can use musl. There are multiple [ncurses implementations].
There _were_ multiple [X Implementations](https://en.wikipedia.org/wiki/XFree86) and that didn't stop because of
the vendor lock in policies that RedHat and GNU engage in. And on the other side, wlroots is far from being the dominant
force in wayland (which is just a standard). Vi and Emacs both have more implementations than I care to name. As do HTTP
daemons, POSIX compatible shells, and C library implementations. This prevents the type of monoculture and frog boiling
we see in most enterprise software.

[^1]: btw

[Arch Linux]: https://archlinux.org/
[OOXML]: http://noooxml.wikidot.com/
[SystemD-RedHat]: https://www.redhat.com/archives/fedora-devel-list/2008-January/msg00861.html
[sudo replacement]: https://mastodon.social/@pid_eins/112353324518585654
[tmuxissue]: https://github.com/tmux/tmux/issues/428
[RMSEML]: https://gcc.gnu.org/legacy-ml/gcc/2000-01/msg00572.html
[ncurses implementations]: https://github.com/sabotage-linux/netbsd-curses
[-ffunction-sections]: https://elinux.org/images/2/2d/ELC2010-gc-sections_Denys_Vlasenko.pdf
