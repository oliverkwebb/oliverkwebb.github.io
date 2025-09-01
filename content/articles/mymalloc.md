---
title: "Implementing an efficient malloc in 50 lines of C"
date: 2025-08-31
tags: ['Programming']
params:
  coverart: /graph/mallocdia.png
---

![A graph explaining the structure of a malloc implementation](/graph/mallocdia.png)

The smallest C libraries will [just mmap each allocation, storing the length immediately before](https://github.com/torvalds/linux/blob/master/tools/include/nolibc/stdlib.h#L127) and [assume any value passed to free is valid](https://github.com/torvalds/linux/blob/master/tools/include/nolibc/stdlib.h#L92). But this leaves plenty of room for optimization and correctness.

The way libc's typically keep track of allocations is with a linked list or other data structure, keeping multiple small allocations on the same page.

This brings the question:

> In linux on x86_64, how can you implement a correct (standards compliant) `malloc()` and `free()` in as little code as possible, whilst still optimizing to some extent?