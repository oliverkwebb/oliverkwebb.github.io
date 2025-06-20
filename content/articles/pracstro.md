---
title: "Practical Astronomy with Your Command Line"
tags: ['Astronomy', 'Programming']
date: 2025-05-23T17:02:40-05:00
---
About a year and a half ago, I was trying to put the current moon phase in my status bar,
Simultaneously I was trying to make other projects that would show the sunrise and sunset time.
There are many open-source tools that can generate astronomical info on linux:

* [Stellarium](https://stellarium.org/) is easily the most extensive astronomy tool out there, acting as a full planetarium and astronomer toolkit.
* [Stellarium Web](https://stellarium-web.org/) - a slightly clunkier version of stellarium for browsers (To picture the level of degradation, think old desktop Google Earth ([flight sim included](https://www.tomsguide.com/how-to/google-earth-has-a-hidden-flight-simulator-heres-how-to-find-it)) vs the web version).
* [Celestia](https://celestiaproject.space/) is a simulator in a similar style to stellarium.
* [JPL Horizons](https://ssd.jpl.nasa.gov/horizons/) is a highly modular data generator that you can telnet into.

Looking to more specific purpose tools:

* [wttr.in/moon](https://wttr.in/moon) - a `curl` service that includes a moon phase generator based off a python rewrite of `phoon`.
* [phoon](https://acme.com/software/phoon/) - a unix moon phase viewer based off the code for `moontool`.
* [moontool](https://www.fourmilab.ch/moontoolw/moontool16.html) - GUI moon phase viewer.
* [sunwait](https://github.com/risacher/sunwait) - sunrise/sunset calculator.
* [plan9 astro(1)](https://9fans.github.io/plan9port/man/man1/astro.html) - astronomical info generator, largely exclusive to plan9.

As cool as all these tools are, there still exists a specific niche in shell scripting that I still couldn't fill.
To properly script/embed these tools in the spirit of classic UNIX, there needs to be a clear way to render the info
in plain text, ideally without sending HTTP requests or using a GUI. There are a lot of things which can do that, but
most of them aren't general purpose enough to generate things like moon phases/sunset times/planet positions all at once.

![A Venn Diagram of Astronomy Tools](/astro-tools-venn.png)

# How easy is it to make something like that?

Lets lessen the scope for a moment, to... lets say moon phases. Which I couldn't find a straightforward way to
get info about without revving up an awk interpreter to strip out text from other things,
using inaccurate approximations, or curling information from the internet.

A year ago, I was looking at [pyphoon](https://github.com/chubin/pyphoon),
and found the [astronomy code](https://github.com/chubin/pyphoon/blob/master/pyphoon/lib/astro.py) from it
was a rewrite of C code written almost [40 years ago](https://www.fourmilab.ch/moontoolw/).

Instead of dividing the current date by twenty-some days and working off the value that returns, this code
could give accurate information about the phase of the moon centuries into the future and past. Along with
information such as angular diameter and distance. And it could do that parsimoniously in around 400 lines
of C (before refactoring).

Stripping out all the GUI code (which would not compile on X since it uses SunOS specific libraries (think
1987 when color monitors running X are the hot new thing)), that code could easily be refactored into [a CLI tool](https://github.com/oliverkwebb/moontool).

```sh
mprintf -h
# mprintf [-h] [-t TIME] [FORMAT]
# -f formats:
# %a Moon Age      %J Julian Day
# %e Emoji         %s Emoji of phase (Southern Hemisphere)
# %p Phase Name    %P Illuminated Percent
# %% Percent Sign  %n Newline

mprintf "%e %P %p"
# 🌘 13.3 Waning Crescent
```

I later transpiled this to [lua](https://github.com/oliverkwebb/moontool/tree/main/lua) and
[rust](https://github.com/oliverkwebb/moontool-rs). But... *how did the original code get the moon phase*,
and how did they come up with the algorithm?

In the header of that code, the book *Practical Astronomy with Your Calculator* by Peter Duffett-Smith is mentioned.
Which explains not just the algorithms behind astronomical calculation, but many aspects of astronomy itself, very well.
This book is actually simpler to transcribe code from than similar books for BASIC/FORTRAN/Forth/C/PASCAL,
since their algorithms are usually restricted to arithmetic, exponentiation, and trig functions.

# How accurate can we be?

TL;DR: Accurate Enough.

**Hyper-Accurate** Astronomy is... [hard](https://www.celestialprogramming.com/snippets/nutation2000a/nutation2000a.html).
Often times it is [impossible](https://en.wikipedia.org/wiki/Extinction_(astronomy)) without [information](https://en.wikipedia.org/wiki/Polar_motion)
that can't be [queried](https://www.news18.com/news/buzz/want-to-see-two-sunsets-in-the-same-evening-burj-khalifa-is-the-place-to-be-4132970.html)
from the user reasonably.

In most astronomical algorithms, you will see approximations for slightly varying factors given in the form of a
polynomial of centuries since some epoch. Even though those formulas diverge to infinity, they are "good enough"
for a range of a few thousand years.

Generally, most "constants" wobble by some small amount over a large period of time due to a large amount of effects.

* The moon is half a degree in the sky (30 arcminutes)
* An arcsecond is the angular diameter of a dime viewed from 2.5 km
* The Hubble Space Telescope has a resolution of around 0.1 arcseconds
* The Gaia telescope can pinpoint star locations down to 7 microarcseconds

| Effect             | Predictable | Caused By          | Max Change in Accuracy                                    |
| ------------------ | ----------- | ------------------ | --------------------------------------------------------- |
| Precession         | Yes         | Wobble             | ~1°/century                                               |
| Parallax           | Yes         | Distance Changes   | 1 degree (lunar), less than 1 arcsec (everything else)    |
| Refraction         | Yes[^1]     | The Atmosphere     | Up to 30 arcmin (near the horizon)                        |
| Pertubation        | Yes         | Newtonion Gravity  | Up to 1.5 degrees                                         |
| Proper Motion      | Yes         | Star Movement      | Less than 5 arcsec per year                               |
| Nutation           | Yes         | Wobble             | ~10 arcsec/20y                                            |
| Polar Motion       | No          | ???                | ~0.1 arcsec/year                                          |
| Extinction         | No          | The Atmosphere     | Varies (effecting visual magnitude)                       |
| Abberation         | Yes         | The Earths Orbit   | Up to 20 arcsec                                           |
| Apsidal Precession | Yes         | General Relativity | Less than 1 arcsec per century                            |

Not all these effects are worth accounting for to the level of picoarcseconds. Many are not worth accounting for at all in a
parsimonious info generator. Some only matter for historical dates or dates far in the future. At the same time,
there is a noticeable difference caused by parallax, refraction, and pertubation.

Correcting for precession, pertubation, refraction, and parallax gives results that are "good enough" for telescope pointing,
observation scheduling, and most real-world uses.

[^1]: Truly Accurate Predictions require temperature, pressure, and altitude measurements, but even without these refraction can be approximated.

# Alogrithms and Plumbing

*Practical Astronomy with Your Calculator* is a very useful source of information, but there are other
collections of algorithms that are just as useful:

* *Astronomical Formulae for Calculators* by Jean Meeus covers most of the same topics, with slightly more accurate algorithms and slightly less
explanation on why they work.
* *https://www.celestialprogramming.com/* provides much more accurate algorithms, in easy to transpile javascript. Along with things like [rotation matrix code](https://www.celestialprogramming.com/snippets/rotationmatrix.html), although with little to no explanation of the algorithms themselves.

As for the plumbing, we can generally break down any calculation into the form `get [PROPERTY] from [OBJECT] assuming [TIME/LATLONG]`[^2].
Creating a table of properties of an object over time is called [ephemeris](https://en.wikipedia.org/wiki/Ephemeris).
Using this model, we can make a simple interface to these algorithms for a command line:

```sh
deskephem -l 45s,0 moon phase
# 🌘 Waning Crescent (8.0%)
deskephem -E now,5d,+3w saturn distance
# ===================================================
#          Date                   Distance           
# ===================================================
#  2025-05-24T13:45:27  10.00 AU                     
#  2025-05-29T13:45:27  9.92 AU                      
#  2025-06-03T13:45:27  9.84 AU                      
#  2025-06-08T13:45:27  9.76 AU                      
#  2025-06-13T13:45:27  9.68 AU   
```

Additionally, output can be added for JSON and CSV, to make parsing data with tools much easier.

# The result?

Lets say you want to graph the distance between the Earth and the other planets in the inner solar system.
Doing this entirely inside the command line with conventional tools is normally a painful process, but using
CSV output, you can generate ephemeris for the 3 other planets (and the sun), and put the distance columns
into your data analysis tool of choice (gnuplot, python, etc...).

![Inner Solar System Distance Graph](/SMVm.png)

It is easy to see why mercury is the ["mostest closest"](https://laughingsquid.com/mercury-is-mostest-closest-planet-to-earth/) with
this graph. You can also see the slight eccentricity of earths, and Mercury's orbit as wobble in the line of the sun, and a
more substantial difference in the wave of Mercury's orbit.

As for the complexity of this tool, it only took 1500 lines of rust (astronomical algorithms included), with 0-dependencies aside from std.
And the algorithms are universal enough to be rewritten to anything with trig functions and floating point math.

The ephemeris generator that came from this research: [deskephem](https://github.com/oliverkwebb/deskephem)

[^2]: Generally, the latitude and longitude is only important in some parallax calculations and in conversion to horizontal coordinates.
