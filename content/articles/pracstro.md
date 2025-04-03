---
title: "Practical Astronomy with Your Rust Compiler"
date: 2025-03-12T17:02:40-05:00
draft: true
---
A year ago, I was looking at a tool called [pyphoon](https://github.com/chubin/pyphoon),
which displays ASCII art of the moon phase along with information about it. And found the
[astronomy code](https://github.com/chubin/pyphoon/blob/master/pyphoon/lib/astro.py) from it
was a rewrite of C code written almost [40 years ago](https://www.fourmilab.ch/moontool/).

Instead of dividing the current date by twenty-some days and working off the value that returns, this code
can give accurate information about the phase of the moon decades into the future and past. But... *how*,
and how did they come up with the algorithm?

In the header of the code, two books are mentioned. *Practical Astronomy with Your Calculator* by Peter Duffett-Smith
and *Astronomical Formulae for Calculators* by Jean Meeus.

