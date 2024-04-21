---
Title: Replacing Neovim with vis
Date: 2024-04-17
---
<title>Replacing Neovim with vis</title>
# Replacing Neovim with vis

Lately, I've been unhappy with neovim and it's bloat. vi is a simple and beautiful tool by
itself, but it's most popular deviation vim has been bloated to the point of being unmanageable
the same way perl took the design of awk or C++ took the design of C and destroyed it.

Neovim remedies this, but not by much. And in place it adds more bloat. Such as a in built
parser that uses memory and processing power that isn't even on by default, "the reason for
linking this?": Slightly better syntax highlighting.  And it's decision on removing build
configuration means that it can't be de-bloated.

And the worst part of this, some of the bloat is actually useful. Bloated software has the
problem of "Everyone only uses 20%, but it's always a different 20%".  This makes the minimalist
vi implementations hard to use. I _want_ syntax highlighting and colorization, I _want_ the
ability to batch process data with ex commands.  I _want_ the ability to select things with
visual line mode. This disqualifies implementations like nextvi, nvi, and busybox vi.

[Kakoune](https://kakoune.org/) seems like a good alternative, until you realize that it's written
in C++, I generally [don't trust C++ people](https://harmful.cat-v.org/software/c++/) with these
types of things. **Especially** when it's a hobby project. The willingness to break everything is
probably a way of venting the fact that C++'s selling point is the fact that it's C compatible, and
this restricts the language massively.

What does this leave? There is apparently one editor called [vis](https://github.com/martanne/vis)
that is fairly minimal, has a large amount of vim-isms, and is written in pure C with configuration
able to be done in lua. It only takes up a few megabytes of space, while vim takes up 60 and
neovim takes up 40. It lacks things like the s, g, and v ex commands. Which by my concerns are
essential. It also picks up stuff from kakoune.

Looking at my vimrc, this is what I want:

- syntax highlighting (Ideally customize-able)
- Binary File Detection with a script on loadtime
- Relative Line Numbers
- "gf" motion

And this would be ideal:

- A customizable bar
- Leading whitespace matching/removal
- Leader Key Toggling of set options
- Tab/Space conversion, Tab managing
- Some way to spellcheck/auto-complete
- Auto-Indenting

Let's look at these individually and see what vis can achieve.

No editor has inbuilt binary file detection by default, but one can customize a editor like vim
or vis to add it in. For vis, I personally did it in a dozen lines of lua that detects weather
or not a file is binary with a simple system command. vis also has inbuilt syntax highlighting,
with a [selection of themes to use](https://github.com/martanne/vis/wiki/Themes). to use.  Vis has
inbuilt options for line numbering (including relative line numbering), tab to space conversion
And autoindenting (Although, Not very good autoindenting).  It also has a semi-customize-able
status bar via the lua API, along with keybindings.

After this point, lua plugins start becoming a _lot_ more important. Fortunately,
there are [a lot of plugins](https://github.com/martanne/vis/wiki/Plugins) to do this
for us. [vis-goto-file](https://repo.or.cz/vis-goto-file.git) for the "gf" motion,
[vis-highlight](https://github.com/erf/vis-highlight) for leading white-space detection.
And [vis-spellcheck](https://gitlab.com/muhq/vis-spellcheck) for spellchecking.

There are also lua plugins I didn't even know I wanted until now, like the ability to auto-format
and edit GFM tables with [vis-tables](https://www.thyssentishman.com/git/vis-tables/log.html).
And backups that are stored in a reasonable place with
[vis-backup](https://github.com/roguh/vis-backup).

That is not to say, vis is not without problems. For example, it is convenient to have the
cursor show up as a bar on insert mode, but show as a block on normal mode, so that you can
tell what mode you are in without looking at the status bar. This would normally be a simple
print statement on changing of modes. But for whatever reason (I think due to the fact that
there is multiple cursor support in vis). This does not change anything.

Some day I might fork vis to remove window management (That's a multiplexers job) and add in
things like customize-able cursor shapes and ex commands. But right now, I've shaped vis to
fit my needs enough to become my default text editor.
In conclusion, if you do not like how bloated and large vim and it's forks are. But find the
features that vim provides useful, you might wanna try vis, which although large-ish, includes
many but not all vim-isms while still being elegant and versatile.
