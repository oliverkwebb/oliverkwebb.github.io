---
title: "Migrating to Hugo"
date: 2024-08-18T12:00:34-05:00
---

This website now runs on [hugo](https://gohugo.io). I migrated the infrastructure off the old static
site generator that was written in Makefile.

## Why?

1. My static site generator isn't that unique, [blogit](https://pedantic.software/git/blogit) already exists.

2. You can do cool things with hugo that you can't with other SSG's (Better markdown compiler, templating, etc)

3. Hugo isn't _that_ large compared to other web frameworks

## What I don't like.

1. Isn't generalized enough

2. Mystified language to make it's features sound cooler

`archetype`
: `hugo new content` template

`shortcode`
: Macro

`partial`
: Template that isn't a whole webpage

_default
: Base templates

## Markdown playground

Insert emojis: :wave:

- ==highlighted text==
- super^scripts^
- ~~Strike-through~~
- ++Underlined++
- Referring[^1]

- [ ] Checkboxes

- [X] Checkboxes


```c
static char *f(void) {
	return " display highlighted code"+1;
}
```

View github gists:
{{< gist oliverkwebb 8b05751e685a01c6a2c71c2a8de69052 >}}

[And many more](https://gohugo.io/about/features/)

[^1]: To footnotes
