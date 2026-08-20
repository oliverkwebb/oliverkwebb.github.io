---
title: "TTF Font Rendering on Rust ESP32's for EPaper"
date: 2026-08-20T00:21:10-05:00
params:
  coverart: /graph/fonttypes.png
---

Most embedded graphics libraries can't directly render TTF fonts, instead, they convert bitmap fonts (usually bdf fonts) to a binary format.
Since there is no consensus on what this format is, what it allows, and what generates it. The tooling for embedded fonts in any language, much less TTF ones in Rust,
is shaky and at times dysfunctional.

{{< figure src="/graph/font-dep-graph.png" caption="The pipeline between common font formats and rusts `embedded_graphics` text renderer" width="300" >}}

There are many things a font can be, all with special performance optimizations.

{{< figure src="/graph/fonttypes.png" >}}

- Monospace bitmap fonts require the least overhead, usually just being a large array.
- Proportional bitmap fonts require storing metrics for each glyph.
- Scalable fonts require a TTF parser and a rasterizer.

For small, embedded displays, stylized fonts aren't much use in a small display size, and computation time is expensive. So it makes sense to only support fonts in the first or second category.
However, for large, low refresh rate displays (epaper), there is much more time to compute between refreshes, and much more space for stylized text.

Memory is the limiting factor of whether or not we can render ttf fonts on an embedded device. The size of the libraries (and data) in the flash memory, and data structures on the stack/heap.

From here, we can take any rasterizer from the many that exist, and attempt to use it in conjunction with `embedded_graphics`. I chose [`fontdue`](https://github.com/mooman219/fontdue) as the starting point.
Mainly because it has a predefined way of positioning glyphs (which is needed for `embedded_graphics`)

## Optimizing Non-Embedded Libraries for Embedded?

Since computation cost is almost free for low-refresh rate devices, memory is the only thing that matters.
I am working with an ESP32S3, with the following memory budget:

| Stage            | Flash   | Stack | Heap  |
| ---------------- | ------- | ----- | ----- |
| Budget (ESP32S3) | 12000KB | 32KB  | 220KB |

This will vary wildly even on the same chip since these settings can be changed. I am representing all numbers in KB to show that
flash memory space is essentially free compared to stack and heap. What matters is that if sum of all the stages of processing get
close to or above the memory budget, the program panics and fails.

Fontdue, what we are basing this test off of, has a 3 stage pipeline between TTF font data in storage and glyphs being drawn to a display.
Parsing with `ttf_parser` before laying out and rasterizing glyphs using its own internal code.

Using a custom allocator to monitor heap usage, and `mem::size_of` for data structure size/stack usage, running fontdue on a 100KB Latin font, we get the following:

| Stage                | Flash    | Stack     | Heap    |
| -------------------- | -------- | --------- | ------- |
| TTF Font Data        | 100KB    | 0         | 0       |
| Library Data         | ~50KB(?) | 0         | 0       |
| `ttf_parser::Face`   | 0        | 1.5KB     | 0       |
| `fontdue::Font`      | 0        | ~0        | 3100KB  |
| `fontdue::layout`    | 0        | ~0.5KB(?) | ~1KB(?) |
| **Cost**             | ~150KB   | 2KB       | 3100KB  |
| **Budget** (ESP32S3) | 12000KB  | 32KB      | 220KB   |

Unideal.

## Optimizing Heap Usage by at Least 15x (or 150x)

2KB of stack usage[^1] is also unideal for more constrained chips, but that can be turned into heap usage with `Arc`.
The more interesting problem is that it's allocating 30 times the ttf data size on the heap... why?

Looking at the [source code](https://docs.rs/fontdue/latest/src/fontdue/font.rs.html#189), there are four culprits:

- `glyphs`: A vector of all glyph geometry.
- `char_to_glyph`: A hashmap from unicode characters to glyph index numbers[^2].
- `horizontal_kern`: A hashmap of kerning values.

The last, and biggest culprit, is the fact that there isn't a `ttf_parser::Face` structure in the `fontdue::Font` structure, which means
all the data from the font is being stored in the `fontdue::Font` structure.

Including the `ttf_parser::Face` structure, which we have already wrapped in `Arc` to prevent stack overflows,
makes the font much more flexible (allowing for variable fonts, for instance) and gives us a more memory efficient way of accessing data.
It makes every method of generating data used during [struct initialization](https://docs.rs/fontdue/latest/src/fontdue/font.rs.html#242)
available on the fly, more particularly [this 20 line lambda function](https://docs.rs/fontdue/latest/src/fontdue/font.rs.html#289).

By moving that lambda out of the function, [changing vertical bars to parenthesis, and replacing references into the `glyphs` vector with it](https://github.com/iriswebb/femtofont/commit/fcde37be2bc05cec70770e2d368fc285de1525a6),
we can run our tests again to get the following table:

| Stage                | Flash    | Stack     | Heap    |
| -------------------- | -------- | --------- | ------- |
| TTF Font Data        | 100KB    | 0         | 0       |
| Library Data         | ~50KB(?) | 0         | 0       |
| `ttf_parser::Face`   | 0        | 1.5KB     | 0       |
| `fontdue::Font`      | 0        | ~0        | 19KB    |
| `fontdue::layout`    | 0        | ~0.5KB(?) | ~1KB(?) |
| **Cost**             | ~150KB   | 2KB       | 20KB    |
| **Budget** (ESP32S3) | 12000KB  | 32KB      | 220KB   |

Ideal!

## Even Better?

For what it's worth, there is more to do from here, `core_float_math` and `portable_simd` can make the renderer noticeably faster compared to its [x86-only optimizations](https://docs.rs/fontdue/latest/src/fontdue/platform/simd_x86.rs.html). And less caching can get 20KB down to 0, so that instead of caching all the time, there's an [optional cache](https://github.com/iriswebb/femtofont/blob/master/src/font.rs#L177) which can be used when memory is less important and speed is slightly more important.

The biggest thing this is missing, when compared to full-featured font stacks, is shaping. And the first-class way to do shaping with rust is... with a [different font stack](https://docs.rs/read-fonts)? That's maintained while `ttf_parser` isn't?[^3] Even enough tooling uses the old one that [cosmic_text](https://docs.rs/cosmic-text/) has both in its dependency tree?

In the future, I'll look at [parley's](https://docs.rs/parley/latest/parley/) memory budget. But since I have gotten TTF text rendering to work natively on an ESP32, I will look at it another day.

{{< figure src="/femtofont-showcase.png" caption="[femtofont](https://github.com/iriswebb/femtofont), running on an epaper display" width="300" >}}

[^1]: This is because ttf-parser keeps a large amount of table data in a similarly large data structure after initial parsing.

[^2]: For many reasons, ttf fonts store their glyphs in a large table with a `cmap` look up table translating unicode codepoint numbers to indexes in that table.

[^3]: Ughhhhhhh.
