---
title: "The C Time API, Rethought"
draft: true
date: 2024-09-07T10:25:12-05:00
---

Out of all the components of C, its time API is probably the one most plagued with legacy cruft.
To the point almost every regularly used element of it has some design decision that's been obsolete for
decades.

As a example, here is some code I use to print the current time for my status bar

```
#include <stdio.h>
#include <time.h>
#include <unistd.h>
int main(void)
{
  char buf[40];
  time_t now = time(0);
  while (1) {
    strftime(buf, 40, "%a %b %d %T", localtime(&now));
    puts(buf);
    fflush(stdout);
    sleep(1);
    now = time(0);
  }
}
```

- `time()` unnecessarily takes a pointer argument to write to
- `strftime()` has to write to a string of a *fixed length* it *can not dynamically allocate* (This is less legacy than it is bad design)
- `localtime()` needs the pointer to a time_t value *even though it does not change it* because of register size concerns on PDP-11's
- `sleep()` cannot sleep for sub-second amounts of time, `usleep()` is deprecated and it's alternative `nanosleep()` requires you to define variables

This is possibly the simplest real-world use of the C time API. And even then the legacy cruft and bad design makes this code significantly less organic.

For comparison, here is the corresponding lua code

```lua
while true do
	print(os.date("%a %b %d %T"))
	io.stdout:flush();
	if not os.execute("sleep 1") then return 1; end
end
```

I'm making my own C time API not because I expect it to have widespread use. But as a proof of concept of what could've been, and to illustrate some of the subtler design flaws of the time library.

## Scope

I will be using the functions described in Eric S. Raymond's *[Time, Clock, and Calendar Programming In C][Time Programming Guide]*
as a boundary for the C time API. These forty-something functions can be classified as:

- Alarm/Timer (`alarm()`, `ualarm()`, the `timer_` group)
- Getting the current time (`time()`, `clock_gettime()`, `getttimeofday()`, `ftime()`, `timespec_get()`)
- Setting the current time (`settimeofday()`, `clock_settime()`)
- NTP correction (`adjtime()`/`adjtimex()`)
- Converting system time to calendar format (`localtime()`, `gmtime()`, and their variants)
- Convertint calendar time to system format (`mktime()`, `timegm()`, `timelocal()`, and their variants)
- Sleeping (`sleep()`, `usleep()`, `nanosleep()`)
- Converting a time to a string (`asctime()`, `ctime()`, and their variants, as well as `strftime()`)
- Converting a string to a time (`getdate()` and `strptime()`)
- Timezone handling (`tzset()`, and the Berkeley timezone API)
- Clock handling (`clock()`, `clock_getres()`)

The only function that doesn't fit here is `difftime()`, which swears it isn't just a subtraction.
Although in libc's such as musl, [it's actually just a subtraction](https://git.musl-libc.org/cgit/musl/tree/src/time/difftime.c).

Out of these, clock handling, system level APIs for setting the time, Alarm/Timer handling (which has as much to do with signals as it does time),
And NTP correction are probably out of scope. This leaves:

- Getting the current time
- Converting system time to calendar format
- Convertint calendar time to system format
- Converting a time to a string
- Converting a string to a time
- Timezone handling
- Sleeping

The main types of the C time API (that matter to us) are:

- `time_t`, which in practice is a 64 bit signed integer of seconds since 1/1/1970 00:00:00 UTC.
- `struct tm`, a broken down (both literally and figuratively) representation of calendar time.
- `struct timespec`, a representation of fractional time in seconds and nanoseconds.
- `timezone_t`, a BSD exclusive opaque timezone type.

`time_t` and `struct timespec` are used almost exclusively in kernel-level functions. Whilst `struct tm` is used
almost exclusively with conversion of time to and from strings.

## Nanoseconds, Floating Point Percision, and the Y2262 problem

It would be awfully convenient to represent time in nanosecond form everywhere all of the time.
It'd give strftime and strptime the ability to print mili/micro/nanoseconds. And it'd remove the need for
the timespec struct used in a lot of system-level time functions.

Because of this, in my time library, the base time type (`date_t`) should contain the number of nanoseconds since the Unix Epoch.

A floating point number is able to store values up to 2^mantissa_length^ with integral precision. Actually, calculating floating
point precision loss is surprisingly easy. For a number n; Any number below 2^n^ will have at least 2^n-mantissa_length^ precision.
Which means for any resolution, we will lose precision at 2^mantissa_length^ *units of that resolution* regardless of base resolution.

For a quick proof of this, lets consider a long double base resolution of 1 second.
We lose nanosecond level precision when 2^n-63^ is 10^-9^.
Which means we lose precision at around ~2^33^ seconds.

```
$ date -d "@$((2**33))"
Wed Mar 16 07:56:32 AM CDT 2242
```

If this were to have nanosecond level precision, we'd lose precision at 2^63^ nanoseconds (Around 2262 (The 20 year difference is due to the fact
that 10^-9^ is actually around 2^-29.8^)).

Using [some go code] I was able to generate the following table:

{{< csvtbl >}}
Type/Resolution, float, int, double, long/x87 long double
Width, 23, 31, 52, 63
1 ns, 1970-01-01T00:00, 1970-01-01T00:00, 1970-02-22T02:59, 2262-04-11T23:47
-1 ns, 1969-12-31T23:59, 1969-12-31T23:59, 1969-11-09T21:00, 1677-09-21T00:12
10 ns, 1970-01-01T00:00, 1970-01-01T00:00, 1971-06-06T05:59, 4892-10-07T21:52
-10 ns, 1969-12-31T23:59, 1969-12-31T23:59, 1968-07-28T18:00, -0953-03-26T02:07
1 us, 1970-01-01T00:00, 1970-01-01T00:35, 2112-09-17T23:53, 294247-01-10T04:00
-1 us, 1969-12-31T23:59, 1969-12-31T23:24, 1827-04-16T00:06, -290308-12-21T19:59
1 ms, 1970-01-01T02:19, 1970-01-25T20:31, 144683-05-23T16:29, 292278994-08-17T07:12
-1 ms, 1969-12-31T21:40, 1969-12-07T03:28, -140744-08-10T07:30, -292275055-05-16T16:47
1 s, 1970-04-08T02:10, 2038-01-19T03:14, 142715360-12-06T03:48, 292277026596-12-04T15:30
-1 s, 1969-09-25T21:49, 1901-12-13T20:45, -142711421-01-25T20:11, 292277026596-12-04T15:30
{{< /csvtbl >}}

Looking at this chart alone, 64 bit integers don't seem much better than long doubles, but keep in mind that
Integers support *One percision*, and there's a tradeoff between resolution and the bounds of your epoch,
Floating point values support *all percisions*, there is no such tradeoff.

For this reason, `date_t` is a long double floating point value of seconds since the epoch.

## "Broken Down Time"

Now that we have a base time type, there needs to be some way to convert between
human friendly to machine friendly values. I.e. getting the year, month and day.
In the spirit of "100 functions for 10 datastructures vs. 10 functions for 1 datastructure",
Unless a functions _job_ is to handle human-friendly time values, it will use `date_t`.

The way this is done in C is with `struct tm` , which has many problems.

* almost always handled in statically allocated pointers that get overwritten (gmtime())
* No way to represent sub-second time.
* tm_mday is based off one for no reason.
* tm_wday and tm_yday make it harder to construct completely-valid timezones
* mktime(), being the main way to convert back into `time_t`, changes the struct that is passed in.

Creating our own calendar structure to fix these problems:

```c
struct cal {
        uint32_t nsec; // 0..1E9
        uint8_t   sec; // 0..60
        uint8_t   min; // 0..59
        uint8_t  hour; // 0..23
        uint8_t   day; // 0..30
        uint8_t month; // 0..11
        date_t   year; // Since Epoch
};
```

With 4 functions to handle them:
```c
extern struct cal tocal(date_t d);
extern int wdayof(date_t d);
extern int ydayof(date_t d);
extern date_t   fromcal(struct cal cal);
```

This fixes several problems with the existing `struct tm`:

* Fractional Time
* Day of month starts with 0 instead of 1
* Years over INT_MAX possible
* Smaller than the `struct tm`
* Any value where the fields are within range corresponds to a unique valid time.

**"Why no timezones in the struct?"**
: The date passed into `tocal()` is ideally already adjusted to a certain timezone with the api later described in this article. The timezone api deals with `date_t`, not calendars on matter of principle and practicality.

## The tragedy of tzset()

Out of all the components of the 

## An illustration of the problem weekdays in time structures creates

`strptime()` is special because it uses uncertainty as a tool. It wont touch anything in the calendar
structure that isn't directly correlated with a formatting specification. This is as much of a
asset as it is a liability, it's useful because you can read time with a set of presumptions
(i.e. read mm/dd as the current year and not 1970). But it's a liability because you can
_unintentionally_ read time with a set of presumptions (i.e. read mm/dd and then
print a wrong weekday because `strptime()` did not correct the weekday).

{{< csvtbl >}}
Date String, Makes Sense?, strptime result?
Febuary 16 1978, Yes, ?? 2/16/78
Febuary 1978, Yes, ?? 2/??/78)
Thursday February 16 1978, Yes, Thur. 2/16/78
Thursday February 1978, No, Thur. 2/??/78
Monday February 30, No, Mon. 2/30/??
{{< /csvtbl >}}

The alternative I provide in my time library is `readdate()`, reading time with a configurable set of base
presumptions (i.e. "the year is 2024") is too valuable not to pass up. For this reason, `readdate()` takes
a base date argument, converts it to a calendar, then changes values in that, before converting it back into a date and returning it.

This has multiple benefits over `strptime()`, the first one is that you are conc

{{< csvtbl >}}
Date String, Makes Sense?, readdate result?
Febuary 16 1978, Yes, 2/16/78
Febuary 1978, Yes, 2/??/78
Thursday February 16 1978, Yes, 2/16/78
Thursday February 1978, No, Yes 2/??/78
Monday February 16, No, 2/16/??
{{< /csvtbl >}}

[Time Programming Guide]: https://www.catb.org/~esr/time-programming/index.asc
[some go code]: https://gist.github.com/oliverkwebb/87e841fe8cb0ad4d3eebc99c38b91a4
