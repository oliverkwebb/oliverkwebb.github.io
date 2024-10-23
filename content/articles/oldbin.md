---
title: "The Oldest Binary on a Mint System"
date: 2024-09-19T21:59:45-05:00
---
Simple question with a simple answer: What is the oldest binary on a Linux mint ISO (modification time)? I was playing around with the stat command more than a year ago when I asked this to myself.
Running a quick shell pipeline `stat -c "%Z %z %n" /bin/* | sort -rn`. The oldest 5 binaries you get are all older than 2011, these are (from oldest -> newest):

* dirsplit - A perl script with little online documentation and unknown use within the distro.
* search4files - A wrapper around 3 programs, none of them installed by default.
* mplayerdvd - Which requires mplayer-gui, not installed by default.
* vlcdvd - Which persists on the system after you remove VLC.
* Thunar-daemon - Which is on systems even where thunar is not installed.

While that does answer the question, it also brings up a much greater question; Why are these scripts and wrappers installed on my system when they probably aren't used anywhere anymore?

## Lets compare

Comparing this with the GUI version of the gentoo livecd (Which contains a full KDE-plasma environment), the 5 oldest binaries are all from after 2020, and the 5th oldest one is from 2024, these are:

* pram - A tool for managing github PR's.
* symtree - A simple tool for tracking symbol information.
* g-lensfun-update-data - A half-dozen line shellscript for a program about photography.
* could-init-per - A shell script wrapper for a python utility.
* pa-info - A bash script for pulseaudio.

It also should be noted that the gentoo GUI livecd provides a much fuller environment than the mint livecd ISO.

## Replication

The real answer to the question of why "search4files" is on the mint livecd is that some Debian or Ubuntu or Mint developer in the mid 2000s put it
on there to manage another GUI application. And it was forgotten about and left on years after it ceased its usefulness. And that Mint, or Ubuntu
which mint is based off of is a massive pile of enterprise software with cruft and out of date parts.

This also means there is probably no formal process for replicating a Mint or Ubuntu ISO. Gentoo users build there entire system from the ground up,
arch users have pacstrap and know the core packages they need. debian has debootstrap. And if I would want to I could theoretically replicate these
tools to create my own bootstrapped for those distros, then I could modify it to truly customize my distribution.

##
