---
Title: The Decline and Fall of my contributions to the Toybox mailing list: My side of the story
Date: 2024-05-01
---
# The Decline and Fall of my contributions to the Toybox mailing list: My side of the story

#### Warning: This article is interpersonal drama that doesn't really matter

So, I've just been banned from the toybox mailing list. I made another account
that I'm planing to use for read-only updates, but I see a decent chance of that
being deleted too.

"Why?": Behind every story, there are 2 sides, I've tried the best on my end to
acknowledge both in this article. Rob is already extensively and dramatically,
giving his side on [his blog](https://www.landley.net/notes.html). But he omits
important background info, which makes me seem less reasonable.

This article will go into what happened, why I believe it happened, and what it
meant in the grand scheme of things

## How things were

I returned to toybox development a competent programmer in [February](http://lists.landley.net/pipermail/toybox-landley.net/2024-February/030029.html).
And I spent most of that month doing various janitorial work on things like [xzcat](http://lists.landley.net/pipermail/toybox-landley.net/2024-February/030077.html) and [bc](http://lists.landley.net/pipermail/toybox-landley.net/2024-February/030067.html).
This was the start of my momentum, things were building up from here.

The true show of my
efforts towards the project were in [March](http://lists.landley.net/pipermail/toybox-landley.net/2024-March/thread.html), which included more technical discussion than I care to name,
 causing things like the [promotion of a command](http://lists.landley.net/pipermail/toybox-landley.net/2024-March/030103.html),
the debugging of [long lost errors last addressed in October](http://lists.landley.net/pipermail/toybox-landley.net/2024-March/030111.html),
Discussion on what [standards we would conform too](http://lists.landley.net/pipermail/toybox-landley.net/2024-March/030120.html),
mkroot packages that could finally [test toybox](http://lists.landley.net/pipermail/toybox-landley.net/2024-March/030196.html),
among other things.
The fact that I was a hobbyist trying to help is hard to dispute from these messages.
I encourage you to remember this time and compare it to my later activity.

## The start of Rob's egotism

Me becoming a competent programmer also meant that I could start to look at code and
constructively criticize it. Finding issues and suggesting work arounds, forming opinions
based on my experiences with other peoples code.

Enter [Rob Landley](https://www.landley.net), the founder and maintainer of Toybox. I have
nothing against his opinions and technical know-how. But to put it simply, He is very
[egotistical and defensive](http://lists.landley.net/pipermail/toybox-landley.net/2020-June/027956.html) of his code.

## Case Study: Andy Chu's Advice

Toybox has a non-functional bash replacement called [toysh](https://www.github.com/landley/toybox/blob/master/toys/pending/sh.c).
It has had about 15 years of work on it to make it functional.

The reason why a minimal set of utilities is trying to replicate the 84,000 lines of bash
is that Rob Landley [disagrees with](https://landley.net/toybox/roadmap.html#goals) a
technical decision that is older than me and every modern operating system complies to.
With the only argument I've seen to it being a [appeal to tradition](https://github.com/landley/toybox/pull/332#issuecomment-2065460832).

Enter [Andy Chu](https://www.oilshell.org), a former contributor to toybox and the main
maintainer of the Oil Shell, a functional bash replacement. Andy saw Rob's effort and attempted
to [give advice](http://lists.landley.net/pipermail/toybox-landley.net/2020-June/019909.html).
Recommending that Rob work with things like BNF grammar. Telling Rob that with his current model
that he would never finish the shell.

Rob responded to this as a personal attack, not as genuine technical advice. But instead as a
attempt to try and prove that Andy was better than Rob. And responded to it as such:

> Heck, I'll go so far as "not actually very good at this, just persistent". You
> want to demonstrate you're better than me, go for it. I'm unlikely to object.
> (Also unlikely to care.)

This is one fairly minor example, let's look at another that I was involved in. Which
was also a signal of the beginning of the end.

## Case Study: the toysh variable naming thread

Toysh is around 4,500 lines of very terse, cryptic C code. When Rob took a short break
from the project in March. I attempted to navigate through this code to add in features
needed to run the toybox test suite. This, to put it simply, did not go well. Most variables
in toysh have single or double (in the spirit of single) letter variable names, this combined
with functions that are hundreds of lines long.

I sent out a [email to the list](http://lists.landley.net/pipermail/toybox-landley.net/2024-March/030148.html)
addressing this, talking about how this made the code significantly harder to audit through.
I offered my help in adding in better variable names and refactoring code. Rob's response to this was...
I'll let you read the email and decide for yourself:

>> The problem isn't the length as I said, the problem is that there is no convention for the naming
>> of these.
>
>Maybe I should move the file to "pending"?
>
>> No pattern that you can follow, you usually have to go to the start of the function
>> (which can be hundreds of lines up, depending on what you are looking through) and see how it gets
>> assigned (And interacts with other variables that have the exact same problem)
>> 
>> I'd try to replace a lot of these names in a patch (I have already done so for sh_main in a patch
>> that I didn't send because getting the compiler to shut up was more important, will send the patch
>> when I'm sure it won't conflict with anything)
>
>And as I said: if I were to I apply an aesthetic patch which does nothing but
>make the code smell like you, toysh would be all yours and I would never touch
>it again.
>
>> but to be accurate in renaming I have to understand
>> what they are, (The problem I'm trying to fix) which requires either better names to begin with or
>> extensive auditing and debug printf-ing of the code that takes up a lot of time.
>
> Clearly I have been too slow to finish this, and it's time for you to take over.
> Your aesthetic sense is empirically superior to mine, I stand chastized.

## Adressing the counterargument: Rob being tired

I recognize the fact that Rob Landley is often over exhausted. And justify
some of his actions with it. It is the reason why I see his side as reasonable.
But there are problems with using this argument to justify all of Rob's actions
that need to be addressed to show that my side is reasonable.

The main source of Rob's abrasiveness is not the fact he's tired, it is the
fact that he's egotistical. The fact that he is tired only serves to amplify this.
If he was merely tired, I would not act in the way I do. But Rob uses this as a
excuse to take out any anger from having his ego hurt on people.

Me [pointing out](http://lists.landley.net/pipermail/toybox-landley.net/2024-April/030309.html)
that Rob could take a break at any time has been misrepresented on [his blog](https://landley.net/notes.html#16-04-2024)
to something akin to me trying to usurp the project. What he doesn't mention is the
difference between reading and responding. Where he has already stated that responding
takes [significantly more effort](https://landley.net/notes.html#06-04-2024).
This is one of many instances of Rob Landley massively exaggerating what I state
to the point of it being barely distinguishable from lying. It is the reason I do
not trust him by himself to give a accurate description of events, and instead provide
links to both and let you decide which side you agree with.

## Adressing a counterargument: Time useage

I understand that Rob is busy and does not want to spend all his time responding to
my emails. But there is a middle ground between a complete embargo of all patches,
even bug fixes and patches that respond to people on github. And responding to every
message. Rob very easily could've balanced this is a reasonable manner, but instead
chose to completely ignore my work and let it pile up. And as a result of his choice,
work piled and piled up until I don't even know how to start categorizing it.

## Most of what I learned, I learned from toybox

Beyond this point, to properly see my side of the situation; You need to understand the fact
that most of what I learned, I learned from Rob and toybox. When I came to toybox in September,
I was a beginner C programmer that couldn't code their way out of a wet paper bag. And I slowly
improved through months of hard work and research until I reached the level where I could genuinely
improve projects.

I took a "When in Rome" approach initially, following what others did, taking advice and style
of speech from them. And when I became good enough to look at people not as all knowing, but
instead as knowledgeable people who's ideas should be listened to as much as they should be
challenged and criticized constructively. The following went and the style of talking remained.
Let's look at 2 cases

## Case Study: Rob's reply to Rich Felker on the settimeofday() deprecation

[Rich Felker](https://musl.libc.org), maintainer of the musl standard C library. Has
deprecated and removed the system call settimeofday(), which is the only way to change
the kernel time zone. This is because of conflicts with kernel timezone's and various filesystem
timestamping. This [came up](https://github.com/landley/toybox/pull/479) in relation to
the hwclock command. And Rich chimed in to give an explanation, lets see how Rob responds:

The initial explanation:
>The right solution here is to always set hardware clock to UTC and tell Windows you did that if
>you use Windows. Storing local time in the hardware clock across boots is always, inherently,
>subject to corruption of the system time if you reboot near the start/end of daylight time. [...]
>
>The "kernel timezone" thing done by settimeofday is a historical GNU/Linux misfeature that musl
>intentionally did not copy, not only because of the above, but because of a much more insideous
>thing Linux does if it's been set. Aside from using kernel timezone for hardware clock purposes,
>it's also used to apply an offset to FAT-based filesystem timestamps; AFAIK there is no way to
>disable this. This means that file timestamps get corrupted on removable USB media, and breaks
>older-than relationships between files if you move the media between devices with different
>timezones.

Robs response which ignores that:
>Once again you don't like code that the kernel has, intentionally break it, and demand users change their behavior. Got it.
>
>I'll wrap the system call.

A repeated explanation to Rob's belittlement and portrayal of Rich as irrational:
>musl is not a lite glibc clone. It does not attempt to mimic the GNU/Linux system. What it
>does attempt to do is provide a POSIX-conforming platform with a reasonable set of extensions [...]
>not that facilitate setting up your system exactly the same way you might be familiar
>with setting it up using GNU/Linux.
>
>If you want your version of the hwclock utility to use this functionality via raw syscall, that's
>probably possible, [...]
>
>BTW, per the man page:
>    No doubt it is a bad idea to use this feature.

And repeated not listening to rational explanation, execpt phrashed different
> Rich removed the __NR_settimeofday constant from musl in commit 5a105f19b5aa because he believes
> people shouldn't have the choice to use kernel features he disapproves of.

And finally, one last vain attempt to provide valid explanation that Rob isn't listening to
or evidently cares about:
> No I did not. If you bothered to read the text of the commit, all of the syscalls that take
> time32 arguments were renamed to have a _time32 suffix so that you can continue using them, [...]

This is ignoring a repeated no with valid technical explanation to portray the other as incompetent.
Lets look at a case where Rob *thinks* this is happening merely because he refused to read into
the technical explanation, and as a consequence turns a unfortunate situation into a downright un-salvageable
one

## Case Study: The utf8towc() thread

I was doing UTF-8 work for a project related to toybox. And stumbled upon undocumented behavior in
the function utf8towc() (Which is meant to be a replica for [mbrtowc()](https://www.man7.org/linux/man-pages/man3/mbrtowc.3.html)
from libc). Where if you passed in a NULL byte, it would return 0 instead of 1. This makes converting memory
with null bytes to wide characters more annoying. I submitted a patch for this on the [mailing list](http://lists.landley.net/pipermail/toybox-landley.net/2024-April/030272.html)

This is admittedly a situation where I probably acted a bit too abrasive, which was my honest mistake.
In a reply email to Rob's initial reply I suggested multiple times that the comment above the function
could just be changed to document this behavior, Rob did not read these threads. And assumed I was being
irrational:

>> Still, U+0000 is a valid code point, and having a special case especially for it
>> that isn’t mentioned but you have to watch out for is either a bug or a
>> documentation error.
>
> I say it's intentional, you reassert that I'm wrong.
>
> I'll leave you to your opinion...

## Rob Boycotting my patches, and me contributing to github issues

After this, Rob started to [ignore my messages](https://www.landley.net/notes.html#08-04-2024), whether
they were minor fixes, technical questions, or pokes about the large amount of patches piling up. To the
point where I posted twice as much as him in the month of April. Naturally, not being able to make progress
on anything encourages me to find other stuff to do to keep momentum.

This is where the incoming github issues came into play, working with literally anyone else is better than
working with Rob a large fraction of the time. And I *knew* how to fix most of the bugs that were coming in.
Or at least give my 2c in a way that I knew Rob would agree with. So I did, naturally, Rob saw this as a
attempt to [usurp him](https://landley.net/notes.html#15-04-2024), because the model he has of open source
contributions doesn't make room for people trying to help others.

The sad part of this is that these people will likely have to wait considerably longer then they normally
would if I didn't hurt Rob's ego one too many times because the code is already on the list. But Rob will
not look at it since it was written by me.

## Rob driving away hobbyists is normal

The toybox "community" is comprised with Rob, enh, a few paid android devs here and there, a occasional hobbyist
who does not work directly with the project but still is associated with them. And that's pretty much it, "The reason why?":
Rob alienated everyone that would want to work with his code. I've personally seen this happen multiple times with multiple
people. Maybe later I will write a case study, but a good example is a Rob responding to a (admittedly snarky, but still valid)
[question about modernizing his website](https://github.com/landley/toybox/issues/490) not with the actual answer ("Servers too slow"),
but with a non-answer of "I'm sorry your browser can't render plain HTML", which he continued into other issues (If a honest question
you asked was treated like that, would you come back? The guy asking them didn't).

## End of the line

After Rob published his 4/8 and 4/6 blog posts about how he was starting to boycott my patches, I
[pointed out to him](http://lists.landley.net/pipermail/toybox-landley.net/2024-April/030337.html)
that he alienated everyone that would wanna work with toybox, and I only acted the way I did because
I was responding to "ruthless pragmatism ("pragmatism")" with ruthless pragmatism. This to him was
unacceptable, and he force-unsubscribed me from the mailing list.

## What this means for the future

I literally can't direct any more development effort into making toybox better. But that doesn't mean
I'm not gonna contribute to projects adjacent to toybox or try to pry the menuconfig fork from the infrastructure
the same way I did the test suite. I am also doing minimal system bootstrapping and the knowledge from mkroot
will help me.

## Conclusion

Toybox was a excellent project to get a bearing on software development, low level C code, working
with libc and the linux API, and many, many other things on. The technical knowledge I gained from
it was priceless. But the person behind it's repeated egotistical behavior, derision, and belittlement
ruined it not just for me, but for other hobbyists. And now, it's time to move on to other, different
things.
