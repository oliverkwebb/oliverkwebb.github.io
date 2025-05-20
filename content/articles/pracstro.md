---
title: "Practical Astronomy with Your Rust Compiler"
date: 2025-04-29T17:02:40-05:00
draft: true
---
A year ago, I was looking at a tool called [pyphoon](https://github.com/chubin/pyphoon),
which displays ASCII art of the moon phase along with information about it. And found the
[astronomy code](https://github.com/chubin/pyphoon/blob/master/pyphoon/lib/astro.py) from it
was a rewrite of C code written almost [40 years ago](https://www.fourmilab.ch/moontoolw/).

Instead of dividing the current date by twenty-some days and working off the value that returns, this code
could give accurate information about the phase of the moon centuries into the future and past. Along with
information such as angular diameter and distance.

I later refactored that code into [a CLI tool](https://github.com/oliverkwebb/moontool), along with
rewrites in [lua](https://github.com/oliverkwebb/moontool/tree/main/lua) and
[rust](https://github.com/oliverkwebb/moontool-rs). But... *how did the original code get the moon phase*,
and how did they come up with the algorithm?

In the header of that code, the book *Practical Astronomy with Your Calculator* by Peter Duffett-Smith is mentioned.
Which explains not just the algorithms behind astronomical calculation, but many aspects of astronomy itself, very well.
This book is actually simpler to transcribe code from than similar books for BASIC/FORTRAN/Forth/C/PASCAL,
since their algorithms are usually restricted to arithmetic, exponentiation, and trig functions.

# Time (and Angles)

Functions that work with time and angles are largely the same, to the point where in the actual algorithms
of the book have a lot of boilerplate to convert between representations of time/angular displacement.
Removing and abstracting over this boilerplate leaves you more room to think about the calculations being
preformed rather than semantics.

Time and Angular Displacement are so similar because they both represent [*modular arithmetic*](https://en.wikipedia.org/wiki/Modular_arithmetic) at their core.

The Earths rotation can be divided into 360 degrees, 24 hours, 2π radians, or 1 [turn](https://en.wikipedia.org/wiki/Turn_(angle)), but they are all analogous with each other.

![RELATION BETWEEN ANGLE AND TIME](/graph/AngleTime.png)
