---
title: "The Unix Philosophy is Just Modular Functional Programming"
tags: ['Programming', 'Rust', 'C', 'Theory', 'Opinion', 'History']
date: 2025-06-20T11:15:57-05:00
draft: true
---

# C is a DSL

The model C works with is just a Turing machine. You have a large array
of bytes that is your memory, which you can change and branch with, and
you can jump to and refer to labeled addresses.

It's simpler than many Turing machine "emulators" because your instructions
are in the "tape" of your memory, and because there is no way to do I/O in
raw C. The way I/O is done in C is via syscalls, which need assembly to work.

This model isn't designed to be abstracted upon, nor to be friendly, you
can't write code quickly with it, you can't analyze code quickly with it
either, isn't designed with the intent of large amounts of structure. **It
is domain-specific**.

That domain is tasks that need to be done as efficiently as possible.
In the '70s, C was created as a portable language to write the UNIX kernel
in. Since then, it has became the centerpiece of kernel development. In
userspace, most libraries, languages, and tools are still either written in
C or delegate the processor intensive work to it.



The reason why it is so unpleasant to make anything large scale in
C is because **C was not meant to be used alone**.

# Type Theory in the Filesystem

# Filters and Maps

