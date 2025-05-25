---
title: "Astronomy and Earth: Coordinate Distances"
date: 2025-05-24T19:07:58-05:00
---
You might of heard the phrase ["dig to china"](https://www.mentalfloss.com/article/27585/could-you-really-dig-hole-china) before,
or talked about digging a b-line through the earth to some far off land jokingly. But how much distance would you actually save
by digging through the earth instead of traveling along the surface?

Since coordinates on a sphere are 2 dimensional, lets think of a simpler problem. On a unit circle where both locations
positions can be represented by one angle, what's the difference between going through the circle versus traveling
along its circumference?

Well, we need to get the difference between these two angles, which is just another angle that you can get by subtraction,
from here `crd` (`2*sin(0.5*x)`) can do the work trivially.

{{< trinket circle-sec >}}

Extending this problem into 2d, what can we do?

Well, any two points on a sphere form a great circle. This immediately reduces the problem back into the first 2d one.
We can get the angle between the two points on the great circle using:

```
arccos(sin(long1) * sin(long2) + cos(long1) * cos(long2) * cos(lat1 - lat2))
```

Multiplying the resulting chord by the earths radius, we can approximately get a distance calculation for digging
through the earth between any two coordinates.

{{< trinket sphere-sec >}}

# How does this relate to astronomy?

When calculating the phase (illuminated fraction and bright limb position) of planets, you
work with a "phase angle" that is the angle between the Earth, that planet, and the sun.
With (`(1-cos(x))/2`), you can turn this number into an illuminated fraction.

How do you calculate this angle? Imagine a triangle between the sun, earth, and planet,
we have the length of the Earth-Sun line (1AU within a rounding error for these calculations),
and the length of the Earth-Planet line (if your ephemeris generator doesn't give distances,
find something different).

We need the sun-earth-planet angle to have enough info
to law-of-cosines the desired result. And if we have the coordinates of the sun and planet (which should be trivial to find
at this stage), we can take the angle between these two coordinates on the celestial sphere. And have enough info
to get the phase angle from coordinates and distance alone.
