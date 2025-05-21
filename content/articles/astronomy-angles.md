---
title: "Astronomy: Time is an Angle"
date: 2025-05-20T16:08:15-05:00
---
The time of day as an idea needs no introduction.

{{< trinket current-time >}}

But what does it *represent*, really? Well, it represents a fraction of a rotation (the Earth's), which makes it an Angle.

In many astronomical calculations, angles are represented as time to make certain conversions easier. For example,
the horizontal coordinate of [Algol](https://en.wikipedia.org/wiki/Algol) is 03:08:10.13 (Usually written 03h08m10.13s).

If you disregard the fact that this is a coordinate and treat it as a time of day,
you can convert this time to your [local mean siderial time](https://en.wikipedia.org/wiki/Sidereal_time), and get
the hour angle (also written as a time), which its location on the celestial equator relative to you, or rather,
how much the celestial sphere has rotated in comparison to the prime meridian.

Since in astronomy, angles are sometimes represented as time, why not represent time as an angle?

# The 360 hour clock, the 2π hour clock, and the 1 hour clock[^1]

{{< trinket current-time-angle >}}

In 4 minutes, the earth rotates 1 degree around its axis, and in about 4 hours, it rotates one radian.
This is useful since it can give a vague idea of how much objects will move in the sky. The sun takes
up about half a degree of view in the sky, so a sunset will take a minimum of two minutes.

![Conversion between angle units and time units](/graph/AngleTime.png)

Venus takes up about 1/60th of a degree of view. So it could only take 4 seconds to move its own
diameter in the sky, which is good to know for telescope readjustment ("If I leave my telescope alone,
I'll be able to see X for at least Y amount of time").

Using degrees in place of hours on a clock, or using "turns" (the fraction of the day) gives
results that are interesting, but don't deserve much cometary.

![Places on Earth where it can be 100 degrees in the morning](/places100deg.png)

# The Tangent of Time

Why radians? To take trig functions, of course!

{{< trinket tangent-of-time >}}

Whilst taking trig functions on your coordinates can yield interesting results
(the cosine of your latitude is how long your line of latitude is, compared to the equator).
These don't seem to map to anything interesting and non-obvious.

[^1]: The term "12-hour clock" is valid even though it describes a 24 hour day
