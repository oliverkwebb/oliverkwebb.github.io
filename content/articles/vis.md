---
Title: Replacing Neovim with vis
Date: 2024-04-17
---
Lately, I've been unhappy with neovim and it's bloat. vi is a simple and beautiful tool by
itself, but it's most popular deviation vim has been bloated to the point of being unmanageable
the same way perl took the design of awk or C++ took the design of C and destroyed it.

Neovim remedies this, but not by much. And in place it adds more bloat. And it's decision
on removing build configuration means that it can't be de-bloated in the spirit of tiny vim
builds.

And the worst part of this, some of the bloat is actually useful. Bloated software has the
problem of "Everyone only uses 20%, but it's always a different 20%". This makes the minimal
vi implementations hard to use. I _want_ syntax highlighting and colorization, I _want_ the
ability to batch process data with ex commands.  I _want_ the ability to select things with
visual mode. This disqualifies implementations like nextvi, nvi, and busybox vi.

What does this leave? There is apparently one editor called [vis](https://github.com/martanne/vis)
that's minimal, has a large amount of vim-isms, and is written in pure C with configuration able to
be done in lua. It only takes up a couple megabytes of space, while vim takes up 60 and neovim takes
up 40. It lacks things like the s, g, and v ex commands in favor of multi-cursor editing.

vis also has inbuilt syntax highlighting, with a [selection of themes to use](https://github.com/martanne/vis/wiki/Themes).
vis has inbuilt options for line numbering (including relative line numbering), tab to space conversion
And autoindenting (Although, Not very good autoindenting). It also has a semi-customize-able
status and keybindings bar via the lua API.

Here are some features that aren't in vis _by default_:

- "gf" motion
- Leading whitespace detection
- Some way to spellcheck/auto-complete

Let's look at these individually and see what vis can achieve.

There are [a lot of plugins](https://github.com/martanne/vis/wiki/Plugins) to do these things:
- [vis-goto-file](https://repo.or.cz/vis-goto-file.git): for the "gf" motion,
- [vis-highlight](https://github.com/erf/vis-highlight): for leading white-space detection.
- [vis-spellcheck](https://gitlab.com/muhq/vis-spellcheck): for spellchecking.

There are also lua plugins I didn't even know I wanted until now, like the ability to auto-format
and edit markdown tables with [vis-tables](https://www.thyssentishman.com/git/vis-tables/log.html).
And backups that are stored in a reasonable place with [vis-backup](https://github.com/roguh/vis-backup).

That is not to say, vis is not without problems. For example, it is convenient to have the
cursor show up as a bar on insert mode, but show as a block on normal mode, so that you can
tell what mode you are in without looking at the status bar. This would normally be a simple
print statement on changing of modes. But for whatever reason (I think due to the fact that
there is multiple cursor support in vis). This does not change anything.

If you do not like how bloated and large vim and it's forks are. But find the features that
vim provides useful, Vis includes many but not all vim-isms while still being elegant and
versatile.
